figure
plot([grid_results.physical_mass_ratio.ratio{:}], [grid_results.physical_mass_ratio.speed{:}],'b','LineWidth',2)
hold on
title("Avg. Speed vs Ratio")
xlabel("Ratio")
ylabel("Speed")
plot([grid_results.shape_mass_ratio.ratio{:}], [grid_results.shape_mass_ratio.speed{:}],'r')
plot([grid_results.shape_mass_ratio_epbc.ratio{:}], [grid_results.shape_mass_ratio_epbc.speed{:}],'g','Marker','*','MarkerSize',20)
%plot([grid_results.epbc.ratio{:}], [grid_results.epbc.speed{:}],'magenta','Marker','^','MarkerSize',20)
legend({'$\mu$','$\bar{\mu}$','$\bar{\mu}$ + ET', 'ET' },'Interpreter','latex')

figure
plot([grid_results.physical_mass_ratio.steplength{:}], [grid_results.physical_mass_ratio.speed{:}],'b','LineWidth',2)
hold on
title("Avg. Speed vs Step Length")
xlabel("Step Length")
ylabel("Speed")
plot([grid_results.shape_mass_ratio.steplength{:}], [grid_results.shape_mass_ratio.speed{:}],'r')
plot([grid_results.shape_mass_ratio_epbc.steplength{:}], [grid_results.shape_mass_ratio_epbc.speed{:}],'g','Marker','*','MarkerSize',20)
%plot([grid_results.epbc.steplength{:}], [grid_results.epbc.speed{:}],'magenta','Marker','^','MarkerSize',20)
legend({'$\mu$','$\bar{\mu}$','$\bar{\mu}$ + ET', 'ET' },'Interpreter','latex')

set(0,'DefaultAxesXGrid','on')
set(0,'DefaultAxesYGrid','on')
set(0,'DefaultFigureWindowStyle','docked')
for i=0:length(grid_results.epbc.xout)-1
    figure('Name',strcat("Vel = ", num2str(grid_results.epbc.speed{end-i})))
    subplot(2,2,1)
    plot(grid_results.physical_mass_ratio.tout{end-i}, grid_results.physical_mass_ratio.xout{end-i}(:,3),'b')
    hold on
    plot(grid_results.shape_mass_ratio.tout{end-i}, grid_results.shape_mass_ratio.xout{end-i}(:,3),'r')
    plot(grid_results.shape_mass_ratio_epbc.tout{end-i}, grid_results.shape_mass_ratio_epbc.xout{end-i}(:,3),'g')
    %plot(grid_results.epbc.tout{end-i}, grid_results.epbc.xout{end-i}(:,3),'magenta')
    title("Ankle Pos vs Time")
    xlabel("Time (s)")
    ylabel("deg")
    legend({'$\mu$','$\bar{\mu}$','$\bar{\mu}$ + ET', 'ET' },'Interpreter','latex')

    subplot(2,2,2)
    plot(grid_results.physical_mass_ratio.tout{end-i}, grid_results.physical_mass_ratio.xout{end-i}(:,4),'b')
    hold on
    plot(grid_results.shape_mass_ratio.tout{end-i}, grid_results.shape_mass_ratio.xout{end-i}(:,4),'r')
    plot(grid_results.shape_mass_ratio_epbc.tout{end-i}, grid_results.shape_mass_ratio_epbc.xout{end-i}(:,4),'g')
    plot(grid_results.epbc.tout{end-i}, grid_results.epbc.xout{end-i}(:,4),'magenta')
    title("Knee Pos vs Time")
    xlabel("Time (s)")
    ylabel("deg")
    legend({'$\mu$','$\bar{\mu}$','$\bar{\mu}$ + ET', 'ET' },'Interpreter','latex')

    subplot(2,2,3)
    plot(grid_results.physical_mass_ratio.tout{end-i}, grid_results.physical_mass_ratio.xout{end-i}(:,7),'b')
    hold on
    plot(grid_results.shape_mass_ratio.tout{end-i}, grid_results.shape_mass_ratio.xout{end-i}(:,7),'r')
    plot(grid_results.shape_mass_ratio_epbc.tout{end-i}, grid_results.shape_mass_ratio_epbc.xout{end-i}(:,7),'g')
    plot(grid_results.epbc.tout{end-i}, grid_results.epbc.xout{end-i}(:,7),'magenta')
    title("Ankle Vel vs Time")
    xlabel("Time (s)")
    ylabel("deg/s")
    legend({'$\mu$','$\bar{\mu}$','$\bar{\mu}$ + ET', 'ET' },'Interpreter','latex')

    subplot(2,2,4)
    plot(grid_results.physical_mass_ratio.tout{end-i}, grid_results.physical_mass_ratio.xout{end-i}(:,8),'b')
    hold on
    plot(grid_results.shape_mass_ratio.tout{end-i}, grid_results.shape_mass_ratio.xout{end-i}(:,8),'r')
    plot(grid_results.shape_mass_ratio_epbc.tout{end-i}, grid_results.shape_mass_ratio_epbc.xout{end-i}(:,8),'g')
    plot(grid_results.epbc.tout{end-i}, grid_results.epbc.xout{end-i}(:,8),'magenta')
    title("Knee Vel vs Time")
    xlabel("Time (s)")
    ylabel("deg/s")
    legend({'$\mu$','$\bar{\mu}$','$\bar{\mu}$ + ET', 'ET' },'Interpreter','latex')
end

set(0,'DefaultFigureWindowStyle','normal')
set(0,'DefaultAxesXGrid','off')
set(0,'DefaultAxesYGrid','off')