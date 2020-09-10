%Mass Ratio
figure
hold on
plot([search_results.physical_mass_ratio.ratio{:}],[search_results.physical_mass_ratio.speed{:}]);
plot([search_results.shape_mass_ratio.ratio{:}],[search_results.shape_mass_ratio.speed{:}],'--');
%plot([search_results.shape_mass_ratio_epbc.ratio{:}],[search_results.shape_mass_ratio_epbc.speed{:}],'*');
%legend({'Physical','Shaped','Shape+EPBC'})
legend({'$\mu$','$\bar{\mu}$'},'Interpreter','latex')
xlabel('Ratio','Interpreter','latex')
ylabel('Avg. Speed $\frac{m}{s}$','Interpreter','latex')
title('Mass Ratio vs Speed','Interpreter','latex')
xmin = max([min([search_results.physical_mass_ratio.ratio{:}]),min([search_results.shape_mass_ratio.ratio{:}]),min([search_results.shape_mass_ratio_epbc.ratio{:}])]);
xmax = min([max([search_results.physical_mass_ratio.ratio{:}]),max([search_results.shape_mass_ratio.ratio{:}]),max([search_results.shape_mass_ratio_epbc.ratio{:}])]);
ymin = max([min([search_results.physical_mass_ratio.speed{:}]),min([search_results.shape_mass_ratio.speed{:}]),min([search_results.shape_mass_ratio_epbc.speed{:}])]);
ymax = min([max([search_results.physical_mass_ratio.speed{:}]),max([search_results.shape_mass_ratio.speed{:}]),max([search_results.shape_mass_ratio_epbc.speed{:}])]);
axis([0.9*xmin, 1.1*xmax,0.9*ymin,1.1*ymax])

setfigprops

%Length Ratio
figure
hold on
plot([search_results.physical_length_ratio.ratio{:}],[search_results.physical_length_ratio.speed{:}]);
plot([search_results.shape_length_ratio.ratio{:}],[search_results.shape_length_ratio.speed{:}],'--');
%plot([search_results.shape_length_ratio_epbc.ratio{:}],[search_results.shape_length_ratio_epbc.speed{:}],'*');
%legend({'Physical','Shaped','Shape+EPBC'})
legend({'$\beta$','$\bar{\beta}$'},'Interpreter','latex')
xlabel('Ratio','Interpreter','latex')
ylabel('Avg. Speed $\frac{m}{s}$','Interpreter','latex')
title('Length Ratio vs Speed','Interpreter','latex')
xmin = max([min([search_results.physical_length_ratio.ratio{:}]),min([search_results.shape_length_ratio.ratio{:}]),min([search_results.shape_length_ratio_epbc.ratio{:}])]);
xmax = min([max([search_results.physical_length_ratio.ratio{:}]),max([search_results.shape_length_ratio.ratio{:}]),max([search_results.shape_length_ratio_epbc.ratio{:}])]);
ymin = max([min([search_results.physical_length_ratio.speed{:}]),min([search_results.shape_length_ratio.speed{:}]),min([search_results.shape_length_ratio_epbc.speed{:}])]);
ymax = min([max([search_results.physical_length_ratio.speed{:}]),max([search_results.shape_length_ratio.speed{:}]),max([search_results.shape_length_ratio_epbc.speed{:}])]);
axis([0.9*xmin, 1.1*xmax,0.9*ymin,1.1*ymax])

setfigprops