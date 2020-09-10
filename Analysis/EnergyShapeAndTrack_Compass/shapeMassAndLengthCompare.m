%% Adaptive Search Results
% figure;
% d1 = plot([search_results.physical_mass_ratio.ratio{:}],[search_results.physical_mass_ratio.speed{:}],'*');
% hold on 
% d2 = plot([search_results.shape_mass_ratio.ratio{:}],[search_results.shape_mass_ratio.speed{:}],'*');
% d3 = plot([search_results.shape_mass_ratio_epbc.ratio{:}],[search_results.shape_mass_ratio_epbc.speed{:}],'*');
% xlabel('Mass Ratio', 'Interpreter', 'latex')
% ylabel('Speed $\frac{m}{s}$', 'Interpreter', 'latex')
% legend({'$\mu$','$\bar{\mu}$','$\bar{\mu}$ EPBC'}, 'Interpreter', 'latex')
% setfigprops
% axis([0,11,0.55,0.85])
% d1.Marker = '*';
% d2.Marker = '*';
% d3.Marker = 'p';
% 
% figure;
% d4 = plot([search_results.physical_length_ratio.ratio{:}],[search_results.physical_length_ratio.speed{:}],'*');
% hold on 
% d5 = plot([search_results.shape_length_ratio.ratio{:}],[search_results.shape_length_ratio.speed{:}],'*');
% d6 = plot([search_results.shape_length_ratio_epbc.ratio{:}],[search_results.shape_length_ratio_epbc.speed{:}],'*');
% xlabel('Length Ratio', 'Interpreter', 'latex')
% ylabel('Speed $\frac{m}{s}$', 'Interpreter', 'latex')
% legend({'$\beta$','$\bar{\beta}$','$\bar{\beta} EPBC$'}, 'Interpreter', 'latex')
% setfigprops
% axis([0,3,0.55,1.05])
% d4.Marker = '*';
% d5.Marker = '*';
% d6.Marker = 'p';

%% Grid Search Results
%speed vs ratio
figure;
d1 = plot([grid_results.physical_mass_ratio.ratio{:}],[grid_results.physical_mass_ratio.speed{:}],'LineStyle','none','Marker','*','MarkerSize',20);
hold on 
d4 = plot([grid_results.shape_mass_ratio_epbc_adaptive_speed.ratio{:}],[grid_results.shape_mass_ratio_epbc_adaptive_speed.speed{:}],'LineStyle','none','Marker','s','MarkerSize',20);
d2 = plot([grid_results.shape_mass_ratio.ratio{:}],[grid_results.shape_mass_ratio.speed{:}],'LineStyle','none','Marker','+','MarkerSize',20,'MarkerFaceColor','g','MarkerEdgeColor','g');
d3 = plot([grid_results.shape_mass_ratio_epbc_ball.ratio{:}],[grid_results.shape_mass_ratio_epbc_ball.speed{:}],'LineStyle','none','Marker','o','MarkerSize',20);
xlabel('Mass Ratio', 'Interpreter', 'latex')
ylabel('Speed m/s', 'Interpreter', 'latex')
legend({'$\mu$','$\bar{\mu}, u^{vel}_t$','$\bar{\mu}$','$\bar{\mu}, u^{nat}_t$,'}, 'Interpreter', 'latex')
setfigprops

figure;
d5 = plot([grid_results.physical_length_ratio.ratio{:}],[grid_results.physical_length_ratio.speed{:}],'LineStyle','none','Marker','*','MarkerSize',20);
hold on 
d8 = plot([grid_results.shape_length_ratio_epbc_adaptive_speed.ratio{:}],[grid_results.shape_length_ratio_epbc_adaptive_speed.speed{:}],'LineStyle','none','Marker','s','MarkerSize',20);
d6 = plot([grid_results.shape_length_ratio.ratio{:}],[grid_results.shape_length_ratio.speed{:}],'LineStyle','none','Marker','+','MarkerSize',20,'MarkerFaceColor','g','MarkerEdgeColor','g');
d7 = plot([grid_results.shape_length_ratio_epbc_ball.ratio{:}],[grid_results.shape_length_ratio_epbc_ball.speed{:}],'LineStyle','none','Marker','o','MarkerSize',20);
xlabel('Length Ratio', 'Interpreter', 'latex')
ylabel('Speed m/s', 'Interpreter', 'latex')
legend({'$\beta$','$\bar{\beta}, u^{vel}_t$','$\bar{\beta}$','$\bar{\beta}, u^{nat}_t$,'}, 'Interpreter', 'latex')
setfigprops

%Torque Squared vs speed
figure;
d1 = plot([grid_results.physical_mass_ratio.speed{:}],[grid_results.physical_mass_ratio.TorqueSq{:}],'LineStyle','none','Marker','*','MarkerSize',20);
hold on 
d4 = plot([grid_results.shape_mass_ratio_epbc_adaptive_speed.speed{:}],[grid_results.shape_mass_ratio_epbc_adaptive_speed.TorqueSq{:}],'LineStyle','none','Marker','s','MarkerSize',20);
d2 = plot([grid_results.shape_mass_ratio.speed{:}],[grid_results.shape_mass_ratio.TorqueSq{:}],'LineStyle','none','Marker','+','MarkerSize',20,'MarkerFaceColor','g','MarkerEdgeColor','g');
d3 = plot([grid_results.shape_mass_ratio_epbc_ball.speed{:}],[grid_results.shape_mass_ratio_epbc_ball.TorqueSq{:}],'LineStyle','none','Marker','o','MarkerSize',20);
ylabel('$U^2$', 'Interpreter', 'latex')
xlabel('Speed m/s', 'Interpreter', 'latex')
legend({'$\mu$','$\bar{\mu}, u^{vel}_t$','$\bar{\mu}$','$\bar{\mu}, u^{nat}_t$,'}, 'Interpreter', 'latex')
setfigprops

figure;
d5 = plot([grid_results.physical_length_ratio.speed{:}],[grid_results.physical_length_ratio.TorqueSq{:}],'LineStyle','none','Marker','*','MarkerSize',20);
hold on 
d8 = plot([grid_results.shape_length_ratio_epbc_adaptive_speed.speed{:}],[grid_results.shape_length_ratio_epbc_adaptive_speed.TorqueSq{:}],'LineStyle','none','Marker','s','MarkerSize',20);
d6 = plot([grid_results.shape_length_ratio.speed{:}],[grid_results.shape_length_ratio.TorqueSq{:}],'LineStyle','none','Marker','+','MarkerSize',20,'MarkerFaceColor','g','MarkerEdgeColor','g');
d7 = plot([grid_results.shape_length_ratio_epbc_ball.speed{:}],[grid_results.shape_length_ratio_epbc_ball.TorqueSq{:}],'LineStyle','none','Marker','o','MarkerSize',20);
ylabel('$U^2$', 'Interpreter', 'latex')
xlabel('Speed m/s', 'Interpreter', 'latex')
legend({'$\beta$','$\bar{\beta}, u^{vel}_t$','$\bar{\beta}$','$\bar{\beta}, u^{nat}_t$,'}, 'Interpreter', 'latex')
setfigprops

Eref_nat =[];
Eref_vel =[];
for i = 1:length(grid_results.shape_length_ratio_epbc_ball.State)
    %params = [grid_results.physical_length_ratio.Parameters{i}.Biped.asvector,9.81];
    %x = grid_results.physical_length_ratio.State{i}.xi;
    Eref_nat(i) = grid_results.shape_length_ratio_epbc_ball.State{i}.extra.Eref;
end

for i = 1:length(grid_results.shape_length_ratio_epbc_adaptive_speed.State)
    %params = [grid_results.shape_length_ratio.Parameters{i}.Shape.asvector,9.81];
    %x = grid_results.shape_length_ratio.State{i}.xi;
    Eref_vel(i) = grid_results.shape_length_ratio_epbc_adaptive_speed.State{i}.extra.Eref;
end
%Energy vs ratio
%d5 = plot([grid_results.physical_length_ratio.ratio{:}],Eref_vel,'LineStyle','none','Marker','*','MarkerSize',20);
hold on 
d8 = plot([grid_results.shape_length_ratio_epbc_adaptive_speed.ratio{:}],Eref_vel,'LineStyle','none','Marker','s','MarkerSize',20);
%d6 = plot([grid_results.shape_length_ratio.ratio{:}],Eref_nat,'LineStyle','none','Marker','+','MarkerSize',20,'MarkerFaceColor','g','MarkerEdgeColor','g');
d7 = plot([grid_results.shape_length_ratio_epbc_ball.ratio{:}],Eref_nat,'LineStyle','none','Marker','o','MarkerSize',20);
xlabel('Length Ratio', 'Interpreter', 'latex')
ylabel('Energy (J)', 'Interpreter', 'latex')
legend({'$\beta, u^{vel}_t$','$\beta, u^{nat}_t$'}, 'Interpreter', 'latex')
setfigprops