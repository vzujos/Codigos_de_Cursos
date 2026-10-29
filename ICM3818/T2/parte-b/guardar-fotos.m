% =========================================================================
%  TAREA 2 - PARTE B: Generación de gráficos
%  Requiere haber ejecutado main.m primero (genera los .mat)
% =========================================================================

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

    for ti = 1:numel(Times)
        t_step = Times(ti);

        % Extraer interiores (sin fantasmas, indices 2:Nxt-1, 2:Nyt-1)
        T_plot   = T_save(2:Nyt-1, 2:Nxt-1, ti) - 273.15;  % °C
        psi_plot = psi_save(2:Nyt-1, 2:Nxt-1, ti);
        w_plot   = w_save(2:Nyt-1, 2:Nxt-1, ti);
        u_plot   = u_save(2:Nyt-1, 2:Nxt-1, ti);
        v_plot   = v_save(2:Nyt-1, 2:Nxt-1, ti);

        % ---- Gráfico 1: T + campo vectorial (u,v) ----------------------
        fig1 = figure('Visible','off','Color','w','Position',[0 0 700 350]);
        ax1  = axes('Parent', fig1);

        if m == 1
            contourf(ax1, x_mm, y_mm, T_plot, 20);
        else
            imagesc(ax1, x_mm, y_mm, T_plot);
            set(ax1, 'YDir', 'normal');
        end

        colormap(ax1, hot);
        cb = colorbar(ax1);
        cb.Label.String = 'Temperatura [°C]';
        clim([min(T_plot(:)), max(T_plot(:))]);
        hold(ax1, 'on');


        % Campo vectorial (diezmado para visibilidad)
        skip = 4;
        [Xq, Yq] = meshgrid(x_mm(1:skip:end), y_mm(1:skip:end));
        Uq = u_plot(1:skip:end, 1:skip:end);
        Vq = v_plot(1:skip:end, 1:skip:end);
        quiver(ax1, Xq, Yq, Uq, Vq, 'w', 'AutoScaleFactor', 0.8, ...
            'LineWidth', 0.8, 'MaxHeadSize', 0.5);

        xlabel(ax1, 'x [mm]'); ylabel(ax1, 'y [mm]');
        title(ax1, sprintf('%s – T(x,y) + v(x,y) – paso %d', mname, t_step));
        hold(ax1, 'off');
        exportgraphics(fig1, sprintf('fotos/T_vel_m%d_t%d.png', m, t_step), ...
            'Resolution', 200);
        close(fig1);

        % ---- Gráfico 2: Función de corriente psi -----------------------
        fig2 = figure('Visible','off','Color','w','Position',[0 0 700 350]);
        ax2  = axes('Parent', fig2);
        
        if m == 1
            [~, h_psi] = contourf(ax2, x_mm, y_mm, psi_plot, 20);
        else
            imagesc(ax2, x_mm, y_mm, psi_plot);
            set(ax2, 'YDir', 'normal');
        end
        colormap(ax2, cool);
        cb2 = colorbar(ax2);
        cb2.Label.String = '\psi [m^2/s]';
        clim([min(psi_plot(:)), max(psi_plot(:))]);

        xlabel(ax2, 'x [mm]');
        xlabel(ax2, 'x [mm]'); ylabel(ax2, 'y [mm]');
        title(ax2, sprintf('%s – \\psi(x,y) – paso %d', mname, t_step));
        exportgraphics(fig2, sprintf('fotos/psi_m%d_t%d.png', m, t_step), ...
            'Resolution', 200);
        close(fig2);

        % ---- Gráfico 3: Vorticidad omega --------------------------------
        fig3 = figure('Visible','off','Color','w','Position',[0 0 700 350]);
        ax3  = axes('Parent', fig3);

        if m == 1
            contourf(ax3, x_mm, y_mm, w_plot, 20);
        else
            imagesc(ax3, x_mm, y_mm, w_plot);
            set(ax3, 'YDir', 'normal');
        end
        colormap(ax3, bluewhitered_approx(256));
        cb3 = colorbar(ax3);
        clim([min(w_plot(:)), max(w_plot(:))]);
        cb3.Label.String = '\omega [1/s]';
        xlabel(ax3, 'x [mm]'); ylabel(ax3, 'y [mm]');
        title(ax3, sprintf('%s – \\omega(x,y) – paso %d', mname, t_step));
        exportgraphics(fig3, sprintf('fotos/omega_m%d_t%d.png', m, t_step), ...
            'Resolution', 200);
        close(fig3);
    end
end

fprintf('Gráficos guardados en fotos/\n');

% -------------------------------------------------------------------------
% Colormap blue-white-red (divergente) para vorticidad
function cmap = bluewhitered_approx(n)
    half = floor(n/2);
    blue_to_white  = [linspace(0,1,half)', linspace(0,1,half)', ones(half,1)];
    white_to_red   = [ones(n-half,1), linspace(1,0,n-half)', linspace(1,0,n-half)'];
    cmap = [blue_to_white; white_to_red];
end

