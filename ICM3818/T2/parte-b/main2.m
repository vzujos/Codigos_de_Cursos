% =========================================================================
% TAREA 2 - PARTE B: Convección de Marangoni en pileta de metal fundido 2D
% Esquema: COMPLETAMENTE IMPLÍCITO en el campo escalar
% Advección: implícita con coeficientes congelados en v^n (upwind corregido)
% =========================================================================

% -------- Parámetros de la malla ----------------------------------------
Nx = 32;
Ny = 32;
Lx = 50e-3;       % largo [m]
Ly = 20e-3;       % alto  [m]
dz = 1e-3;        % espesor [m]

dx = Lx / Nx;
dy = Ly / Ny;

% Con nodos fantasmas: fila/col 1 y Nxt/Nyt son fantasmas
Nxt = Nx + 2;
Nyt = Ny + 2;

% -------- Parámetros temporales -----------------------------------------
dt      = 0.005;
MaxStep = 200;
Times   = [50 100 150 200];

% -------- Parámetros iterativos -----------------------------------------
MaxIt_T   = 5000;
MaxIt_w   = 5000;
MaxIt_psi = 5000;
tol_T     = 1e-3;   % K
tol_w     = 1e-6;   % 1/s
tol_psi   = 1e-8;   % m^2/s
omega_SOR = 1.5;    % factor de relajación para SOR (psi)

% -------- Propiedades de los 3 materiales (Alineado con Tabla 1) --------
mat_names = {'Acero 1040', 'Aluminio 2024-T6', 'Latón C26000'};

K       = [50.7,  151,   120  ];   % W/(m K)
Cp      = [470,   875,   377  ];   % J/(kg K)
Rho_liq = [7850,  2780,  8530 ];   % kg/m^3 (Corregido para coincidir con la teoría)
Tm_C    = [1521,  638,   965  ];   % °C
Tm_K    = Tm_C + 273.15;

mu_dyn    = [6.0e-3, 1.2e-3, 3.5e-3];    % Pa·s
nu        = mu_dyn ./ Rho_liq;           % m^2/s
dsigma_dT = [-4.0e-4, -1.5e-4, -1.3e-4]; % N/(m K)
Alpha     = K ./ Rho_liq ./ Cp;          % m^2/s

% -------- Fuente de calor ------------------------------------------------
Q    = 200;                   % W
qvol = Q / (dx * dy * dz);    % W/m^3

% La fuente se coloca en el PRIMER NODO INTERIOR bajo la superficie libre
% (fila i=Nyt-2), centro horizontal (col j=Nx/2+1 con offset fantasma).
i_src = Nyt - 2;
j_src = round(Nx/2) + 1;

% -------- Denominador fijo para Poisson (psi) ---------------------------
denom_psi = 2/dx^2 + 2/dy^2;

% -------- Bucle principal sobre materiales ------------------------------
for m = 1:3
    fprintf('\n=== Material %d: %s ===\n', m, mat_names{m});

    k_th  = K(m);
    cp_m  = Cp(m);
    rho   = Rho_liq(m);
    nu_m  = nu(m);
    alpha = Alpha(m);
    dsdT  = dsigma_dT(m);
    mu_m  = mu_dyn(m);
    Tm    = Tm_K(m);

    % ---- Inicializar campos ---------------------------------------------
    psi = zeros(Nyt, Nxt);
    w   = zeros(Nyt, Nxt);
    T   = Tm * ones(Nyt, Nxt);

    % BC aislación inicial de T
    T(1,:) = T(2,:);  T(Nyt,:) = T(Nyt-1,:);
    T(:,1) = T(:,2);  T(:,Nxt) = T(:,Nxt-1);

    % Almacenamiento
    psi_save = zeros(Nyt, Nxt, numel(Times));
    w_save   = zeros(Nyt, Nxt, numel(Times));
    T_save   = zeros(Nyt, Nxt, numel(Times));
    u_save   = zeros(Nyt, Nxt, numel(Times));
    v_save   = zeros(Nyt, Nxt, numel(Times));

    for istep = 1:MaxStep

        % ==============================================================
        % Velocidades del paso anterior (Definición cinemática)
        % ==============================================================
        vx = zeros(Nyt, Nxt);   % u = dpsi/dy
        vy = zeros(Nyt, Nxt);   % v = -dpsi/dx
        for i = 2:Nyt-1
            for j = 2:Nxt-1
                vx(i,j) =  (psi(i+1,j) - psi(i-1,j)) / (2*dy);
                vy(i,j) = -(psi(i,j+1) - psi(i,j-1)) / (2*dx);
            end
        end

        % ==============================================================
        % PASO 1: Temperatura — GS completamente implícito (Upwind corregido)
        % ==============================================================
        T_old = T;

        for iter = 1:MaxIt_T
            T_prev = T;

            % Actualizar fantasmas al inicio de cada barrido (BC aislación)
            T(1,:)   = T(2,:);    T(Nyt,:) = T(Nyt-1,:);
            T(:,1)   = T(:,2);    T(:,Nxt) = T(:,Nxt-1);

            for i = 2:Nyt-1
                for j = 2:Nxt-1
                    % Coeficientes de advección upwind corregidos:
                    % vx interactúa con dx (índice j), vy interactúa con dy (índice i)
                    u_p = max( vx(i,j), 0) / dx;   % Viento desde la izq, asimila T(i, j-1)
                    u_m = max(-vx(i,j), 0) / dx;   % Viento desde la der, asimila T(i, j+1)
                    v_p = max( vy(i,j), 0) / dy;   % Viento desde abajo, asimila T(i-1, j)
                    v_m = max(-vy(i,j), 0) / dy;   % Viento desde arriba, asimila T(i+1, j)

                    % Diagonal estrictamente dominante
                    diag_T = 1/dt + u_p + u_m + v_p + v_m ...
                             + 2*alpha/dx^2 + 2*alpha/dy^2;

                    % Término independiente
                    rhs_T = T_old(i,j)/dt;
                    if (i == i_src) && (j == j_src)
                        rhs_T = rhs_T + qvol/(rho*cp_m);
                    end

                    % GS: usa vecinos ya actualizados
                    T(i,j) = ( rhs_T ...
                        + (alpha/dy^2 + v_p) * T(i-1,j) ...   % k+1 (Abajo)
                        + (alpha/dy^2 + v_m) * T(i+1,j) ...   % k   (Arriba)
                        + (alpha/dx^2 + u_p) * T(i,j-1) ...   % k+1 (Izq)
                        + (alpha/dx^2 + u_m) * T(i,j+1) ...   % k   (Der)
                        ) / diag_T;
                end
            end

            % BC aislación al final del barrido
            T(1,:)   = T(2,:);    T(Nyt,:) = T(Nyt-1,:);
            T(:,1)   = T(:,2);    T(:,Nxt) = T(:,Nxt-1);

            if max(abs(T(2:Nyt-1,2:Nxt-1) - T_prev(2:Nyt-1,2:Nxt-1)), [], 'all') <= tol_T
                break
            end
        end

        % ==============================================================
        % PASO 2: Condiciones de borde de vorticidad
        % ==============================================================
        % Paredes sólidas: condición de Thom (No deslizamiento)
        w(2, 2:Nxt-1)      = -2.0 * psi(3, 2:Nxt-1)      / dy^2; % inferior
        w(2:Nyt-1, 2)      = -2.0 * psi(2:Nyt-1, 3)      / dx^2; % izquierda
        w(2:Nyt-1, Nxt-1)  = -2.0 * psi(2:Nyt-1, Nxt-2)  / dx^2; % derecha

        % Superficie libre (Marangoni puramente térmico - Thom fue removido)
        for j = 2:Nxt-1
            dTdx_surf = (T(Nyt-1, j+1) - T(Nyt-1, j-1)) / (2*dx);
            w(Nyt-1, j) = -(dsdT/mu_m) * dTdx_surf; 
        end

        % ==============================================================
        % PASO 3: Vorticidad — GS completamente implícito (Upwind corregido)
        % ==============================================================
        w_old = w;

        for iter = 1:MaxIt_w
            w_prev = w;
            for i = 3:Nyt-2
                for j = 3:Nxt-2
                    % Mismos coeficientes upwind corregidos que en T
                    u_p = max( vx(i,j), 0) / dx;
                    u_m = max(-vx(i,j), 0) / dx;
                    v_p = max( vy(i,j), 0) / dy;
                    v_m = max(-vy(i,j), 0) / dy;

                    diag_w = 1/dt + u_p + u_m + v_p + v_m ...
                             + 2*nu_m/dx^2 + 2*nu_m/dy^2;

                    rhs_w = w_old(i,j)/dt;

                    w(i,j) = ( rhs_w ...
                        + (nu_m/dy^2 + v_p) * w(i-1,j) ...   % k+1 (Abajo)
                        + (nu_m/dy^2 + v_m) * w(i+1,j) ...   % k   (Arriba)
                        + (nu_m/dx^2 + u_p) * w(i,j-1) ...   % k+1 (Izq)
                        + (nu_m/dx^2 + u_m) * w(i,j+1) ...   % k   (Der)
                        ) / diag_w;
                end
            end
            if max(abs(w(3:Nyt-2,3:Nxt-2) - w_prev(3:Nyt-2,3:Nxt-2)), [], 'all') <= tol_w
                break
            end
        end

        % ==============================================================
        % PASO 4: Función de corriente — Poisson con SOR
        % ==============================================================
        for iter = 1:MaxIt_psi
            psi_prev = psi;
            for i = 3:Nyt-2
                for j = 3:Nxt-2
                    psi_GS = ( (psi(i+1,j) + psi(i-1,j))/dy^2 ...
                              + (psi(i,j+1) + psi(i,j-1))/dx^2 ...
                              + w(i,j) ) / denom_psi;
                    psi(i,j) = (1 - omega_SOR)*psi(i,j) + omega_SOR*psi_GS;
                end
            end
            % BC psi = 0 en contornos reales
            psi(2,:)     = 0;   psi(Nyt-1,:) = 0;
            psi(:,2)     = 0;   psi(:,Nxt-1) = 0;

            if max(abs(psi(3:Nyt-2,3:Nxt-2) - psi_prev(3:Nyt-2,3:Nxt-2)), [], 'all') <= tol_psi
                break
            end
        end

        % ==============================================================
        % Verificación y guardado
        % ==============================================================
        if any(isnan(T(:))) || any(isnan(w(:))) || any(isnan(psi(:)))
            fprintf('  WARNING: NaN detectado en paso %d.\n', istep);
            break
        end

        if any(istep == Times)
            idx = find(Times == istep);
            psi_save(:,:,idx) = psi;
            w_save(:,:,idx)   = w;
            T_save(:,:,idx)   = T;
            u_save(:,:,idx)   = vx;
            v_save(:,:,idx)   = vy;
            Tmax = max(T(2:Nyt-1,2:Nxt-1),[],'all') - 273.15;
            wmax = max(abs(w(:)));
            psimax = max(abs(psi(:)));
            fprintf('  Paso %3d | T_max = %7.1f C | |w|_max = %.2e | |psi|_max = %.2e\n', ...
                istep, Tmax, wmax, psimax);
        end
    end

    fname = sprintf('resultados_m%d.mat', m);
    save(fname, 'psi_save','w_save','T_save','u_save','v_save', ...
         'Times','dx','dy','Nx','Ny','Nxt','Nyt','Tm_C','m','mat_names','Tm_K');
    fprintf('Guardado en %s\n', fname);
end

fprintf('\nSimulacion completa.\n');