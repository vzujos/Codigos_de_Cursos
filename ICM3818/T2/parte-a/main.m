% Metodo de Gauss-Seidel
function [xs] = GaussSeidel(A, b, xs, tol, iter)
    N = length(b);
    for k = 1 : iter
        xs_i = xs;
        for i = 1 : N
            xs(i) = ( b(i) - A(i, [1:i-1,i+1:N]) * xs([1:i-1, i+1:N]) ) / A(i,i);            
        end
        if norm(b - A*xs, inf) / norm(b, inf) < tol
            return
        end
    end
    disp('No convergió')
end

% Es la discretizacion del laplaciano
function A = init_matriz_A(nx, ny, dx, dy)
    N = nx * ny;
    A = sparse(N, N);

    for i = 1:nx
        for j = 1:ny
            % indice cool super bomba de la matriz A
            k = (i-1)*ny + j;
    
            % Nodos
            A(k,k) = A(k,k) - 2./dx^2 - 2./dy^2;
    
            if j == 1
                A(k,k) = A(k,k) + 1./dy^2;
                A(k,k+1) = A(k,k+1) + 1./dy^2;
            elseif j == ny
                A(k,k) = A(k,k) + 1./dy^2;
                A(k,k-1) = A(k,k-1) + 1./dy^2;
            else
                A(k,k-1) = A(k,k-1) + 1./dy^2;
                A(k,k+1) = A(k,k+1) + 1./dy^2;
            end

            if i == 1
                A(k,k) = A(k,k) + 1./dx^2;
                A(k,k+ny) = A(k,k+ny) + 1./dx^2;
            elseif i == nx
                A(k,k) = A(k,k) + 1./dx^2;
                A(k,k-ny) = A(k,k-ny) + 1./dx^2;
            else
                A(k,k-ny) = A(k,k-ny) + 1./dx^2;
                A(k,k+ny) = A(k,k+ny) + 1./dx^2;
            end
        end
    end
end


% Parametros iniciales
nx = 32; % subir hasta maximo 32
ny = 32;
nt = 200;
tol = 1e-5;
maxiter = 10000;

dx = 90e-3 ./ nx; % m
dy = 70e-3 ./ ny; % m
dz = 1e-3; % m
dt = 0.5; % s
Q = 200; % W
T0 = 25 + 273.15; % K
T0_C = T0 - 273.15; % °C

hCR = 5.6704e-8 * T0^3 / dz;

%      acero, Al, laton
K     = [50.7 151 120]; % W/(m K)
Cp    = [470 875 377]; % J/(kg K)
Rho   = [7850 2780 8530]; % kg/m3
Tderr = [1521 638 965]; % °C
Alpha = K ./ Rho ./ Cp;

TimesGod = [50 100 150 200]; 

N = nx * ny;

T_exp = T0 * ones(N, nt, 3);
T_imp = T_exp;
T_exp_img = zeros(nx, ny, nt, 3);
T_imp_img = T_exp_img;


disp("dt debe ser como maximo:");
disp( 1./(2*Alpha) ./ (1/dx^2 + 1/dy^2));

A = init_matriz_A(nx, ny, dx, dy);

for m = 1:3
    k = K(m);
    cp = Cp(m);
    rho = Rho(m);
    a = Alpha(m);
    
    q = zeros(N, 1);
    q(1) =  Q ./ (dx*dy*dz);


    % estabilidad para metodo explicito
    FoX = a*dt/dx^2;
    FoY = a*dt/dy^2;
    if (FoX + FoY > 0.5), warning('Esquema explicito inestable.'); end
    
    tic
    for nti = 1:nt-1
        % explitico
        T_exp(:,nti+1,m) = T_exp(:,nti,m) + dt/(rho*cp) * (k*(A*T_exp(:,nti,m)) - hCR*(T_exp(:,nti,m) - T0) + q);

        % implicito
        AA = A - speye(N,N) * (hCR/k + 1/(a*dt));
        bb = - q/k - T_imp(:,nti,m)/(a*dt) - T0*hCR/k;
        T_imp(:,nti+1,m) = GaussSeidel(AA, bb, T_imp(:,nti,m), tol, maxiter);
    end
    toc
end

for i = 1:nx
    for j = 1:ny
        k = (i-1)*ny + j;
        T_exp_img(i,j,:,:) = T_exp(k,:,:) - 273.15;
        T_imp_img(i,j,:,:) = T_imp(k,:,:) - 273.15;
    end
end


%% Esta parte es para calcular la version explicita con Delta t = 0.02 para converger

% Parametros iniciales
dt = 0.02; % s
nt = 200 * 0.5 / 0.02; % para conseguir el mismo tiempo total
NuevosTimes = TimesGod * 0.5 / 0.02;

T_exp_2 = T0 * ones(N, nt, 3);
T_exp_img_2 = zeros(nx, ny, nt, 3);

A = init_matriz_A(nx, ny, dx, dy);

for m = 1:3
    k = K(m);
    cp = Cp(m);
    rho = Rho(m);
    a = Alpha(m);

    q = zeros(N, 1);
    q(1) =  Q ./ (dx*dy*dz);

    tic
    for nti = 1:nt-1
        % explitico
        T_exp_2(:,nti+1,m) = T_exp_2(:,nti,m) + dt/(rho*cp) * (k*(A*T_exp_2(:,nti,m)) - hCR*(T_exp_2(:,nti,m) - T0) + q);
    end
    toc
end

for i = 1:nx
    for j = 1:ny
        k = (i-1)*ny + j;
        T_exp_img_2(i,j,:,:) = T_exp_2(k,:,:) - 273.15;
    end
end

%% Esta es para buscar la max temperatura y en que posicion

function maxT(T, m)
    T_m = T(:,:,:,m);
    [val, idx] = max(T_m(:));
    [i, j, t] = ind2sub(size(T_m), idx);
    {val, i, j, m}
end

for m = 1:3
    disp('Temp maxima implicita')
    maxT(T_imp_img, m)

    disp('Temp maxima explicita')
    maxT(T_exp_img_2, m)

    disp('Temp maxima explicita divergente')
    maxT(T_exp_img, m)
end

%% Esto es para hacer que se mueva la fuente


nx = 32; % subir hasta maximo 32
ny = 32;
dx = 90e-3 ./ nx; % m
dy = 70e-3 ./ ny; % m

N = nx*ny;

dt = 0.02; % s
nt = 200 * 0.5 / 0.02;
TimesGod = [50 100 150 200]; 
NuevosTimes = TimesGod * 0.5 / 0.02;


Tv_exp = T0 * ones(N, nt, 3);
Tv_imp = Tv_exp;
Tv_exp_img = zeros(nx, ny, nt, 3);
Tv_imp_img = Tv_exp_img;

A = init_matriz_A(nx, ny, dx, dy);
qvol = Q ./ (dx*dy*dz);
v = 0.9e-3;

for m = 1:3
    k = K(m);
    cp = Cp(m);
    rho = Rho(m);
    a = Alpha(m);

    tic
    for nti = 1:nt-1
        gamma = nti * dt * v ./ dx;
        deltai = floor(gamma);
        i0 = deltai +1;
        k0 = (i0-1)*ny + 1; % equiv con indice cool

        q = zeros(N,1); % fallara con v muy alto
        if i0 <= nx
            q(k0) = qvol * (1 - (gamma-deltai));

            if (gamma-deltai) > 0 && i0 < nx
                q(k0+ny) = qvol * (gamma-deltai);
            end
        end

        % explitico
        Tv_exp(:,nti+1,m) = Tv_exp(:,nti,m) + dt/(rho*cp) * (k*(A*Tv_exp(:,nti,m)) - hCR*(Tv_exp(:,nti,m) - T0) + q);

        % implicito
        AA = A - speye(N,N) * (hCR/k + 1/(a*dt));
        bb = - q/k - Tv_imp(:,nti,m)/(a*dt) - T0*hCR/k;
        Tv_imp(:,nti+1,m) = GaussSeidel(AA, bb, Tv_imp(:,nti,m), tol, maxiter);
    end
    toc
end

for i = 1:nx
    for j = 1:ny
        k = (i-1)*ny + j;
        Tv_exp_img(i,j,:,:) = Tv_exp(k,:,:) - 273.15;
        Tv_imp_img(i,j,:,:) = Tv_imp(k,:,:) - 273.15;
    end
end
