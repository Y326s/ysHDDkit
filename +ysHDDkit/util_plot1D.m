function util_plot1D(grid, F_plot,name,xlab)

    arguments
        grid
        F_plot
        name = ''
        xlab = ''
    end

    figure('Name',name,'Color', 'w');
    plot(grid, F_plot,  'b.--', 'LineWidth', 1.2);
    xlabel(xlab);
    ylabel('Field');
    title(name);

end