function util_plot2D(G_2d, F_plot,name,plottype,revZ)

    arguments
        G_2d
        F_plot
        name = ''
        plottype = "imagesc"
        revZ = true

    end


    figure('Name',name,'Color', 'w');

    if plottype == "surf"
        fig = surf(G_2d.dim1, G_2d.dim2, F_plot);
        set(fig, 'EdgeColor', 'none')
        view(2);
        if revZ
            set(gca, 'YDir', 'reverse')
        end
    end

    if plottype == "imagesc"
        imagesc(G_2d.dim1(1, :), G_2d.dim2(:, 1), F_plot);    
        if ~revZ
            set(gca, 'YDir', 'normal')
        end
    end


    xlabel('X [m]');
    ylabel('Z [m]');
    title(name);
    colorbar; colormap jet;
    axis equal tight;
    
    clim([-5 0])
    % clim([0 2])


    % xlim([-20 20])
    % ylim([-20 20])
    

end