
path(pathdef)
addpath('Experiments')
addpath('Experiments\EnergyShapeAndTrack_Compass\')
addpath('Analysis\EnergyShapeAndTrack_Compass\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))
clear('temp_exp_results')
tic 
results_to_plot = 'search_epbc';
for j = 1:length(grid_results.(results_to_plot).ratio)
    
    p_com_exp = zeros(length(xout),3);
    v_com_exp = zeros(length(xout),3);
    R_gf = flowdata.getRgf;
    xout = grid_results.(results_to_plot).xout{j};
    for i = 1:length(xout)
        p_com_exp(i,:) = (R_gf(1:3,1:3)*COM_pos_func(xout(i,:)')')'; %put results in normal-tangent coordinates
        v_com_exp(i,:) = (R_gf(1:3,1:3)*COM_vel_func(xout(i,:)')')';
    end
    
    temp_exp_results{j}.p_com = p_com_exp;
    temp_exp_results{j}.v_com = v_com_exp;
    temp_exp_results{j}.gain = flowdata.Parameters.KPBC.k;
end
toc
figure
hold on
for j = 1:length(grid_results.(results_to_plot).ratio)
    x = temp_exp_results{j}.v_com(:,2);
    y = temp_exp_results{j}.p_com(:,2);
    i = y > 0.7;
    plot(x(i),y(i))
end
grid on