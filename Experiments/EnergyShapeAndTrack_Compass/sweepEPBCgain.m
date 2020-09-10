
path(pathdef)
addpath('Experiments')
addpath('Experiments\EnergyShapeAndTrack_Compass\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

tic 

%Experiment parameters
gain_list = [0,0.1,1,2.5,5,10,100,1000];
scale = 1.05;

clear flowdata
initializeCompassGaitLimitCycle

%Add Control Function
flowdata.Controls.Internal = {@Shaping, @KPBC};

%Set parameters
flowdata.Parameters.Shape.Mh = 10;
flowdata.Parameters.Shape.Ms = 5;
flowdata.Parameters.Shape.a = 0.5;
flowdata.Parameters.Shape.b = 0.5;
flowdata.Parameters.Shape.asvector = [10, 5, 0.5, 0.5]; 

flowdata.Parameters.KPBC.k = 0;
flowdata.Parameters.KPBC.omega = diag([0,0,1,0.01]);
flowdata.Parameters.KPBC.sat = inf;
flowdata.Parameters.KPBC.Eref.SSupp = scale*flowdata.E_func(xi',[flowdata.Parameters.Shape.asvector, flowdata.Parameters.Environment.g]);

vector = boolean([0,0,1,1,0,0,1,1]);

flowdata.State.PE_datum = 0;
[fstate, xout, tout, out_extra] = walk(xi.*vector,1);

p_com_0 = zeros(length(xout),3);
v_com_0 = zeros(length(xout),3);
for i = 1:length(xout)
    p_com_0(i,:) = COM_pos_func(xout(i,:)');
    v_com_0(i,:) = COM_vel_func(xout(i,:)');
end
tic 
for j = 1:length(gain_list)
    
    flowdata.Parameters.KPBC.k = gain_list(j);
    flowdata.State.PE_datum = 0;
    [fstate, xout, tout, out_extra] = walk(fstate.*vector,30);

    flowdata.State.PE_datum = 0;
    [fstate, xout, tout, out_extra] = walk(fstate.*vector,1);
    
    p_com_exp = zeros(length(xout),3);
    v_com_exp = zeros(length(xout),3);
    R_gf = flowdata.getRgf;
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
legend_list = {};
for j = 1:length(gain_list)
    plot(temp_exp_results{j}.v_com(:,2), temp_exp_results{j}.p_com(:,2))
    legend_list{j} = strcat('k = ', num2str(temp_exp_results{j}.gain));
end
legend(legend_list)
xlabel('$\dot{y}_{CoM}$','Interpreter','latex')
ylabel('$y_{CoM}$','Interpreter','latex')
grid on
setfigprops