% Params
Nx = 32;
Ny = 32;
Lx = 50e-3;
Ly = 20e-3;
dz = 1e-3;

dx = Lx / Nx;
dy = Ly / Ny;

Nxt = Nx + 2;
Nyt = Ny + 2;

dt        = 0.005;
MaxStep   = 200;
Times     = [50 100 150 200];

MaxIt_T   = 5000;
MaxIt_w   = 5000;
MaxIt_psi = 5000;
tol_T     = 1e-8;
tol_w     = 1e-8;
tol_psi   = 1e-8;

mat_names = {'Acero 1040', 'Aluminio 2024-T6', 'Latón C26000'};
K         = [34, 89.3, 68];
Cp        = [700.4, 1127, 480];
Rho_liq   = [7290, 2391, 7800];
Tm_C      = [1472, 660.32, 925];
Tm_K      = Tm_C + 273.15;
mu_dyn    = [6.4e-3, 1.3e-3, 3.8e-3];
nu        = mu_dyn ./ Rho_liq;
dsigma_dT = [-4.0e-4, -1.3e-4, -3.0e-4];
Alpha     = K ./ Rho_liq ./ Cp;

Q    = 200;
qvol = Q / (dx * dy * dz);
i_src = Nyt - 2;
j_src = round(Nx/2) + 1;
denom_psi = 2/dx^2 + 2/dy^2;

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

    psi = zeros(Nyt, Nxt);
    w   = zeros(Nyt, Nxt);
    T   = Tm * ones(Nyt, Nxt);

    T(1,:) = T(2,:);  T(Nyt,:) = T(Nyt-1,:);
    T(:,1) = T(:,2);  T(:,Nxt) = T(:,Nxt-1);

    psi_save = zeros(Nyt, Nxt, numel(Times));
    w_save   = zeros(Nyt, Nxt, numel(Times));
    T_save   = zeros(Nyt, Nxt, numel(Times));
    u_save   = zeros(Nyt, Nxt, numel(Times));
    v_save   = zeros(Nyt, Nxt, numel(Times));

    for istep = 1:MaxStep
        vx = zeros(Nyt, Nxt);   % u = dpsi/dy
        vy = zeros(Nyt, Nxt);   % v = -dpsi/dx

        for i = 2:Nyt-1
            for j = 2:Nxt-1
                vx(i,j) =  (psi(i+1,j) - psi(i-1,j)) / (2*dy);
                vy(i,j) = -(psi(i,j+1) - psi(i,j-1)) / (2*dx);
            end
        end


        T_old = T;
        for iter = 1:MaxIt_T
            T_prev = T;

            T(1,:)   = T(2,:);    T(Nyt,:) = T(Nyt-1,:);
            T(:,1)   = T(:,2);    T(:,Nxt) = T(:,Nxt-1);

            for i = 2:Nyt-1
                for j = 2:Nxt-1
                    u_p = max( vx(i,j), 0) / dx;
                    u_m = max(-vx(i,j), 0) / dx;
                    v_p = max( vy(i,j), 0) / dy;
                    v_m = max(-vy(i,j), 0) / dy;

                    diag_T = 1/dt + u_p + u_m + v_p + v_m + 2*alpha/dx^2 + 2*alpha/dy^2;

                    rhs_T = T_old(i,j)/dt;
                    if (i == i_src) && (j == j_src)
                        rhs_T = rhs_T + qvol/(rho*cp_m);
                    end

                    T(i,j) = ( rhs_T ...
                        + (alpha/dy^2 + v_p) * T(i-1,j) ...
                        + (alpha/dy^2 + v_m) * T(i+1,j) ...
                        + (alpha/dx^2 + u_p) * T(i,j-1) ...
                        + (alpha/dx^2 + u_m) * T(i,j+1) ...
                        ) / diag_T;
                end
            end

            T(1,:)   = T(2,:);    T(Nyt,:) = T(Nyt-1,:);
            T(:,1)   = T(:,2);    T(:,Nxt) = T(:,Nxt-1);

            if max(abs(T(2:Nyt-1,2:Nxt-1) - T_prev(2:Nyt-1,2:Nxt-1)), [], 'all') <= tol_T
                break
            end
        end


        w(2, 2:Nxt-1)      = -2.0 * psi(3, 2:Nxt-1)      / dy^2;
        w(2:Nyt-1, 2)      = -2.0 * psi(2:Nyt-1, 3)      / dx^2;
        w(2:Nyt-1, Nxt-1)  = -2.0 * psi(2:Nyt-1, Nxt-2)  / dx^2;

        for j = 2:Nxt-1
            dTdx_surf = (T(Nyt-1, j+1) - T(Nyt-1, j-1)) / (2*dx);
            w(Nyt-1, j) = -(dsdT/mu_m) * dTdx_surf; 
        end

        w_old = w;
        for iter = 1:MaxIt_w
            w_prev = w;
            for i = 3:Nyt-2
                for j = 3:Nxt-2
                    u_p = max( vx(i,j), 0) / dx;
                    u_m = max(-vx(i,j), 0) / dx;
                    v_p = max( vy(i,j), 0) / dy;
                    v_m = max(-vy(i,j), 0) / dy;

                    diag_w = 1/dt + u_p + u_m + v_p + v_m + 2*nu_m/dx^2 + 2*nu_m/dy^2;

                    rhs_w = w_old(i,j)/dt;
                    w(i,j) = ( rhs_w ...
                        + (nu_m/dy^2 + v_p) * w(i-1,j) ...
                        + (nu_m/dy^2 + v_m) * w(i+1,j) ...
                        + (nu_m/dx^2 + u_p) * w(i,j-1) ...
                        + (nu_m/dx^2 + u_m) * w(i,j+1) ...
                        ) / diag_w;
                end
            end
            if max(abs(w(3:Nyt-2,3:Nxt-2) - w_prev(3:Nyt-2,3:Nxt-2)), [], 'all') <= tol_w
                break
            end
        end

        omega  = 1.5;
        for iter = 1:MaxIt_psi
            psi_prev = psi;
            for i = 3:Nyt-2
                for j = 3:Nxt-2
                    psi_GS = ( (psi(i+1,j) + psi(i-1,j))/dy^2 ...
                              + (psi(i,j+1) + psi(i,j-1))/dx^2 ...
                              + w(i,j) ) / denom_psi;
                    psi(i,j) = (1 - omega)*psi(i,j) + omega*psi_GS;
                end
            end
            psi(2,:) = 0; 
            psi(Nyt-1,:) = 0;
            psi(:,2) = 0; 
            psi(:,Nxt-1) = 0;

            if max(abs(psi(3:Nyt-2,3:Nxt-2) - psi_prev(3:Nyt-2,3:Nxt-2)), [], 'all') <= tol_psi
                break
            end
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
end

fprintf('\nSimulacion completa.\n');