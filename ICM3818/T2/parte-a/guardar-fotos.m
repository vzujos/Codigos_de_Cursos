x = linspace(0, dx*nx, nx) * 1000;
y = linspace(0, dy*ny, ny) * 1000;

T_imgs = {T_imp_img, T_exp_img, T_exp_img_2};
times = {TimesGod, TimesGod, NuevosTimes};
names = {'imp', 'exp', 'exp'};

max_T_ms = zeros(1,3);
for m = 1:3
    max_T_imp = max(T_imp_img(:,:,:,m),   [], 'all');
    max_T_exp = max(T_exp_img_2(:,:,:,m),   [], 'all');

    max_T_ms(m) = max(max_T_imp, max_T_exp);
end

for m = 1:3

    for im = 1:numel(T_imgs)
        Timg = T_imgs{im};
        Timg_m = Timg(:,:,:,m);
        ntis = times{im};

        for ti = 1:numel(ntis)
            nti = ntis(ti);
            Timg_t_m = Timg_m(:,:,nti);

            fig = figure('Visible', 'off', 'Color', 'w');
            ax = axes('Parent',fig);

            imagesc(ax, x, y, Timg_t_m.');
            set(ax, 'YDir', 'reverse');

            axis(ax, 'tight');
            axis(ax, 'equal');
            colormap(ax, hot);

            cb = colorbar(ax);
            cb.Label.String = 'Temperatura [°C]';

            clim(ax, [25 max_T_ms(m)]);

            hold(ax, 'on');

            [C, h] = contour(ax, x, y, Timg_t_m.', ...
                [Tderr(m) Tderr(m)], ...
                'LineColor', 'w', ...
                'LineWidth', 1.5, ...
                'LineStyle', '--');

            if ~isempty(C)
                clabel(C, h, ...
                    'Color', 'w', ...
                    'FontSize', 10, ...
                    'FontWeight', 'bold', ...
                    'LabelSpacing', 300);
            end
            
            % IA
            text(ax, 0.97, 0.97, sprintf('tiempo: %d', nti), ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'right', ...
                'VerticalAlignment', 'top', ...
                'Color', 'w', ...
                'FontSize', 10, ...
                'Margin', 5);

            hold(ax, 'off');

            exportgraphics(fig, sprintf("fotos/T_%s_%d_%d.png", names{im}, m, nti), 'Resolution', 200);
            close(fig);
        end
    end
end



%% Para guardar las fotos de la fuente que se mueve

x = linspace(0, dx*nx, nx) * 1000;
y = linspace(0, dy*ny, ny) * 1000;

T_imgs = {Tv_imp_img, Tv_exp_img};
times = {NuevosTimes, NuevosTimes};
names = {'vimp', 'vexp'};

max_T_ms = zeros(1,3);
for m = 1:3
    max_T_imp = max(Tv_imp_img(:,:,:,m),   [], 'all');
    max_T_exp = max(Tv_exp_img(:,:,:,m),   [], 'all');

    max_T_ms(m) = max(max_T_imp, max_T_exp);
end

for m = 1:3

    for im = 1:numel(T_imgs)
        Timg = T_imgs{im};
        Timg_m = Timg(:,:,:,m);
        ntis = times{im};

        for ti = 1:numel(ntis)
            nti = ntis(ti);
            Timg_t_m = Timg_m(:,:,nti);

            fig = figure('Visible', 'off', 'Color', 'w');
            ax = axes('Parent',fig);

            imagesc(ax, x, y, Timg_t_m.');
            set(ax, 'YDir', 'reverse');

            axis(ax, 'tight');
            axis(ax, 'equal');
            colormap(ax, hot);

            cb = colorbar(ax);
            cb.Label.String = 'Temperatura [°C]';

            clim(ax, [25 max_T_ms(m)]);

            hold(ax, 'on');

            [C, h] = contour(ax, x, y, Timg_t_m.', ...
                [Tderr(m) Tderr(m)], ...
                'LineColor', 'w', ...
                'LineWidth', 1.5, ...
                'LineStyle', '--');

            if ~isempty(C)
                clabel(C, h, ...
                    'Color', 'w', ...
                    'FontSize', 10, ...
                    'FontWeight', 'bold', ...
                    'LabelSpacing', 300);
            end

            % IA
            text(ax, 0.97, 0.97, sprintf('tiempo: %d', nti), ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'right', ...
                'VerticalAlignment', 'top', ...
                'Color', 'w', ...
                'FontSize', 10, ...
                'Margin', 5);

            hold(ax, 'off');

            exportgraphics(fig, sprintf("fotos/T_%s_%d_%d.png", names{im}, m, nti), 'Resolution', 200);
            close(fig);
        end
    end
end
