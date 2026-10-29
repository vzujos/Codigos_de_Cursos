
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

% -------- Propiedades de los 3 materiales -------------------------------
mat_names = {'Acero 1040', 'Aluminio 2024-T6', 'Latón C26000'};

K       = [50.7,  151,   120  ];   % W/(m K)
Cp      = [470,   875,   377  ];   % J/(kg K)
Rho_liq = [6980,  2400,  7900 ];   % kg/m^3
Tm_C    = [1521,  638,   965  ];   % °C
Tm_K    = Tm_C + 273.15;

mu_dyn    = [6.0e-3, 1.2e-3, 3.5e-3];    % Pa·s
nu        = mu_dyn ./ Rho_liq;            % m^2/s
dsigma_dT = [-4.0e-4, -1.5e-4, -1.3e-4]; % N/(m K)
Alpha     = K ./ Rho_liq ./ Cp;          % m^2/s

% -------- Fuente de calor ------------------------------------------------
Q    = 200;                    % W
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
        % Velocidades del paso anterior (explícitas desde psi^n)
        % ==============================================================
        vx = zeros(Nyt, Nxt);   % vx = dpsi/dy
        vy = zeros(Nyt, Nxt);   % vy = -dpsi/dx
        for i = 2:Nyt-1
            for j = 2:Nxt-1
                vx(i,j) =  (psi(i+1,j) - psi(i-1,j)) / (2*dy);
                vy(i,j) = -(psi(i,j+1) - psi(i,j-1)) / (2*dx);
            end
        end

        % ==============================================================
        % PASO 1: Temperatura — GS completamente implícito
        %
        % Esquema upwind frozen-coefficient implícito:
        %   ρCp * (T^{n+1} - T^n)/dt
        %   + ρCp * vx^n*(T^{n+1}_{i,j} - T^{n+1}_{i∓1,j})/dy  (upwind)
        %   + ρCp * vy^n*(T^{n+1}_{i,j} - T^{n+1}_{i,j∓1})/dx  (upwind)
        %   = k*Lap(T^{n+1}) + q
        %
        % => diag(i,j)*T^{n+1}(i,j) = rhs + [coeff vecinos]*T^{n+1}(vecinos)
        % La diagonal incluye 1/dt + |ax| + |ay| + 2α/dx² + 2α/dy²
        % => diagonalmente dominante => GS converge siempre
        % ==============================================================
        T_old = T;

        for iter = 1:MaxIt_T
            T_prev = T;

            % Actualizar fantasmas al inicio de cada barrido (BC aislación)
            T(1,:)   = T(2,:);    T(Nyt,:) = T(Nyt-1,:);
            T(:,1)   = T(:,2);    T(:,Nxt) = T(:,Nxt-1);

            for i = 2:Nyt-1
                for j = 2:Nxt-1
                    % Coeficientes de advección upwind (frozen en v^n)
                    ax_p = max( vx(i,j), 0) / dy;   % contribución de T(i-1)
                    ax_m = max(-vx(i,j), 0) / dy;   % contribución de T(i+1)
                    ay_p = max( vy(i,j), 0) / dx;   % contribución de T(j-1)
                    ay_m = max(-vy(i,j), 0) / dx;   % contribución de T(j+1)

                    % Diagonal estrictamente dominante
                    diag_T = 1/dt + ax_p + ax_m + ay_p + ay_m ...
                             + 2*alpha/dy^2 + 2*alpha/dx^2;

                    % Término independiente
                    rhs_T = T_old(i,j)/dt;
                    if (i == i_src) && (j == j_src)
                        rhs_T = rhs_T + qvol/(rho*cp_m);
                    end

                    % GS: usa vecinos ya actualizados (i-1,j) y (i,j-1)
                    T(i,j) = ( rhs_T ...
                        + (alpha/dy^2 + ax_p) * T(i-1,j) ...   % k+1
                        + (alpha/dy^2 + ax_m) * T(i+1,j) ...   % k
                        + (alpha/dx^2 + ay_p) * T(i,j-1) ...   % k+1
                        + (alpha/dx^2 + ay_m) * T(i,j+1) ...   % k
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

        % Paredes sólidas: condición de Thom  w = -2*psi_interior/h^2
        w(2, 2:Nxt-1)      = -2.0 * psi(3, 2:Nxt-1)      / dy^2; % inferior
        w(2:Nyt-1, 2)      = -2.0 * psi(2:Nyt-1, 3)      / dx^2; % izquierda
        w(2:Nyt-1, Nxt-1)  = -2.0 * psi(2:Nyt-1, Nxt-2)  / dx^2; % derecha

        % Superficie libre (Marangoni): w = -(dσ/dT)/μ * dT/dx - 2*psi_int/dy²
        for j = 2:Nxt-1
            dTdx_surf = (T(Nyt-1, j+1) - T(Nyt-1, j-1)) / (2*dx);
            w(Nyt-1, j) = -(dsdT/mu_m) * dTdx_surf - 2.0*psi(Nyt-2, j)/dy^2;
        end

        w_old = w;

        for iter = 1:MaxIt_w
            w_prev = w;
            for i = 3:Nyt-2
                for j = 3:Nxt-2
                    ax_p = max( vx(i,j), 0) / dy;
                    ax_m = max(-vx(i,j), 0) / dy;
                    ay_p = max( vy(i,j), 0) / dx;
                    ay_m = max(-vy(i,j), 0) / dx;

                    diag_w = 1/dt + ax_p + ax_m + ay_p + ay_m ...
                             + 2*nu_m/dy^2 + 2*nu_m/dx^2;

                    rhs_w = w_old(i,j)/dt;

                    w(i,j) = ( rhs_w ...
                        + (nu_m/dy^2 + ax_p) * w(i-1,j) ...   % k+1
                        + (nu_m/dy^2 + ax_m) * w(i+1,j) ...   % k
                        + (nu_m/dx^2 + ay_p) * w(i,j-1) ...   % k+1
                        + (nu_m/dx^2 + ay_m) * w(i,j+1) ...   % k
                        ) / diag_w;
                end
            end
            if max(abs(w(3:Nyt-2,3:Nxt-2) - w_prev(3:Nyt-2,3:Nxt-2)), [], 'all') <= tol_w
                break
            end
        end

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
            % BC psi = 0 en bordes reales
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
