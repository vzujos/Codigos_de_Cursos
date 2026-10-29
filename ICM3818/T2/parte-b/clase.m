Nx = 20;
Ny = 20;
MaxStep = 100;
visc = 0.1;
dt = 0.005;
h = 1.0 /Nx;
Uo = 2.0;
MaxIt = 100;
MaxErr = 1e-3;

% Inicializa todas las variables en 0
fc = zeros(Nx, Ny);
w = zeros(Nx, Ny);
wo = zeros(Nx, Ny);
x = zeros(Nx, Ny);
y = zeros(Nx, Ny);

% Genera matriz - x e y - con coo de los nodos en espacio
for i = 1:Nx
  for j = 1:Ny
    x(i, j) = h * (j-1);
    y(i, j) = h * (i-1);
  end
end

wo = fc; % Guarda la funcion de corriente calculada para compararla
for isetp = 1:MaxStep
  for iter = 1:MaxIt
    for i = 2:Ny-1
      for j = 2: Nx-1
        fc(i, j) = 0.25 * (fc(i+1,j) + fc(i-1,j) + fc(i,j+1) + fc(i,j-1) + (h*h)*w(i,j))
      end
    end
    
    Err = 0.0;
    for i = 1:Ny
      for j = 1:Nx
        Err = Err + abs(wo(i,j) - fc(i,j));
      end
    end
    if Err <= MaxErr
      break
    end
  
  % Condiciones de borde para vorticidad en fronteras
  w(1,2:Nx-1) = -2.0 * fc(2,2:Nx-1)/(h*h) + Uo/(h*h); % pared superior
  w(Ny,2:Nx-1) = -2.0 * fc(Ny-1,2:Nx-1)/(h*h); % pared inferior
  w(2:Ny-1,1) = -2.0 * fc(2:Ny-1,2)/(h*h); % pared derecha
  w(2:Ny-1,Nx) = -2.0 * fc(2:Ny-1,Nx-1)/(h*h); % pared izquierda
  wo = w;

  for i = 2:Ny-1
    for j = 2:Nx-1
      w(i,j) = wo(i,j) + dt*(0.25 * ( (fc(i+1,j)-fc(i-1,j)) * (wo(i,j+1)-wo(i,j-1)) - ...
      (fc(i,j-1)-fc(i,j+1)) * (wo(i+1,j)-wo(i-1,j)) )/(h*h) + ...
      4*visc * (wo(i+1,j)+wo(i-1,j)+wo(i,j+1)+wo(i,j-1) -4.0*wo(i,j)) / (h*h) );
    end
  end
end
