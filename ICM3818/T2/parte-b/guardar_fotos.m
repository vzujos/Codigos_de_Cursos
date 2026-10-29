mat_names   = {'Acero 1040', 'Aluminio 2024-T6', 'Latón C26000'};
Tm_C_list   = [1521, 638, 965];
Times       = [50, 100, 150, 200];
mkdir('fotos');

for m = 1:3
    fname = sprintf('resultados_m%d.mat', m);
    load(fname);
    Tm_label = Tm_C_list(m);
    mname    = mat_names{m};
    
    % Coordenadas en mm para graficar
    x_mm = (0:Nx-1) * dx * 1e3;
    y_mm = (0:Ny-1) * dy * 1e3;
    
    % 1. Extraer los campos de todo el tiempo para este material
    T_mat   = T_save(2:Nyt-1, 2:Nxt-1, :) - 273.15;  % °C
    psi_mat = psi_save(2:Nyt-1, 2:Nxt-1, :);
    w_mat   = w_save(2:Nyt-1, 2:Nxt-1, :);
    
    % 2. Calcular límites globales fijos para la colorbar de este material
    T_lims   = [min(T_mat(:)), max(T_mat(:))];
    psi_lims = [min(psi_mat(:)), max(psi_mat(:))];
    
    % Para vorticidad (divergente), forzar centrado en 0
    w_max_abs = max(abs(w_mat(:)));
    if w_max_abs == 0, w_max_abs = 1; end % Evitar límites [0 0]
    w_lims = [-w_max_abs, w_max_abs];

    % Evitar errores si min == max (ej. campo de T inicial constante)
    if T_lims(1) == T_lims(2), T_lims(2) = T_lims(1) + 1; end
    if psi_lims(1) == psi_lims(2), psi_lims(2) = psi_lims(1) + 1e-6; end

    for ti = 1:numel(Times)
        t_step = Times(ti);
        
        % Extraer paso temporal actual
        T_plot   = T_mat(:, :, ti);
        psi_plot = psi_mat(:, :, ti);
        w_plot   = w_mat(:, :, ti);
        u_plot   = u_save(2:Nyt-1, 2:Nxt-1, ti);
        v_plot   = v_save(2:Nyt-1, 2:Nxt-1, ti);
        
        % ---- Gráfico 1: T + campo vectorial (u,v) ----------------------
        fig1 = figure('Visible','off','Color','w','Position',[0 0 700 350]);
        ax1  = axes('Parent', fig1);
        
        % Aplicar contourf a todos los materiales (LineColor none para mayor nitidez)
        contourf(ax1, x_mm, y_mm, T_plot, 20, 'LineColor', 'none');
        colormap(ax1, hot);
        cb1 = colorbar(ax1);
        cb1.Label.String = 'Temperatura [°C]';
        clim(ax1, T_lims); % <-- Aplicar límite fijo global
        hold(ax1, 'on');
        
        % Campo vectorial
        skip = 4;
        [Xq, Yq] = meshgrid(x_mm(1:skip:end), y_mm(1:skip:end));
        Uq = u_plot(1:skip:end, 1:skip:end);
        Vq = v_plot(1:skip:end, 1:skip:end);
        quiver(ax1, Xq, Yq, Uq, Vq, 'w', 'AutoScaleFactor', 0.8, ...
            'LineWidth', 0.8, 'MaxHeadSize', 0.5);
        xlabel(ax1, 'x [mm]'); ylabel(ax1, 'y [mm]');
        title(ax1, sprintf('%s – T(x,y) + v(x,y) – paso %d', mname, t_step));
        hold(ax1, 'off');
        exportgraphics(fig1, sprintf('fotos/T_vel_m%d_t%d.png', m, t_step), 'Resolution', 200);
        close(fig1);
        
        % ---- Gráfico 2: Función de corriente psi -----------------------
        fig2 = figure('Visible','off','Color','w','Position',[0 0 700 350]);
        ax2  = axes('Parent', fig2);
        
        contourf(ax2, x_mm, y_mm, psi_plot, 20, 'LineColor', 'none');
        colormap(ax2, cool);
        cb2 = colorbar(ax2);
        cb2.Label.String = '\psi [m^2/s]';
        clim(ax2, psi_lims); % <-- Aplicar límite fijo global
        xlabel(ax2, 'x [mm]'); ylabel(ax2, 'y [mm]');
        title(ax2, sprintf('%s – \\psi(x,y) – paso %d', mname, t_step));
        exportgraphics(fig2, sprintf('fotos/psi_m%d_t%d.png', m, t_step), 'Resolution', 200);
        close(fig2);
        
        % ---- Gráfico 3: Vorticidad omega --------------------------------
        fig3 = figure('Visible','off','Color','w','Position',[0 0 700 350]);
        ax3  = axes('Parent', fig3);
        
        contourf(ax3, x_mm, y_mm, w_plot, 20, 'LineColor', 'none');
        colormap(ax3, bluewhitered_approx(256));
        cb3 = colorbar(ax3);
        cb3.Label.String = '\omega_z [1/s]';
        clim(ax3, w_lims); % <-- Aplicar límite fijo global simétrico
        xlabel(ax3, 'x [mm]'); ylabel(ax3, 'y [mm]');
        title(ax3, sprintf('%s – \\omega_z(x,y) – paso %d', mname, t_step));
        exportgraphics(fig3, sprintf('fotos/omega_m%d_t%d.png', m, t_step), 'Resolution', 200);
        close(fig3);
    end
end
fprintf('Gráficos generados y guardados en la carpeta fotos/\n');

% -------------------------------------------------------------------------
% Colormap blue-white-red (divergente) para vorticidad
function cmap = bluewhitered_approx(n)
    half = floor(n/2);
    blue_to_white  = [linspace(0,1,half)', linspace(0,1,half)', ones(half,1)];
    white_to_red   = [ones(n-half,1), linspace(1,0,n-half)', linspace(1,0,n-half)'];
    cmap = [blue_to_white; white_to_red];
end