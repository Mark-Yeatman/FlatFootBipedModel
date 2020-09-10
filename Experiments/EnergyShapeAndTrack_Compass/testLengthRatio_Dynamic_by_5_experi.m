%Demonstrates changing walking speeds in the 2 Link compass gait biped through shaping the
%LENGTH RATIO between the shank and hip masses. Uses an adaptive energy
%tracking control to increase the basin of attraction of the gaits.
clear all
path(pathdef)
addpath('Experiments\EnergyShapeAndTrack_Compass\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))
global flowdata

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.do_validation = false;

%Simulation parameters
flowdata.Parameters.Environment.slope = -deg2rad(3.7);   %ground slope
g = 9.81;
flowdata.Parameters.Environment.g = g;
flowdata.Parameters.dim = 8;        %state variable dimension

%Discrete Mappings and Constraints
flowdata.setPhases({'SSupp'})
flowdata.setConfigs({})
impactlist =  {'FootStrike'};
e1 = struct('name','FootStrike','nextphase','SSupp','nextconfig','');
e2 = struct('name','FallForward','nextphase','Failure','nextconfig','');
e3 = struct('name','FallBackward','nextphase','Failure','nextconfig','');
flowdata.Phases.SSupp.events = {e1,e2,e3};
flowdata.End_Step.event_name = 'FootStrike';

%Set initial phase, contact conditions, and state
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts();
currentdirectory = pwd;
load(strcat(currentdirectory ,'\Experiments\EnergyShapeAndTrack_Compass\Data\grid_results.mat'))

%Base case
load('xi.mat')
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

disp("Base case")
[fstate, xout, tout, out_extra] = walk(xi,3);

%% Shaping Parameter Change by Step
x_total = xout;
t_total = tout;

flowdata.Controls.Internal = {@Shaping,@KPBC};

%KPBC Parameters
flowdata.Parameters.KPBC.k = 1;
flowdata.Parameters.KPBC.omega = diag([0,0,1,0.1]);
flowdata.Parameters.KPBC.sat = inf;

%Eref update law Parameters
flowdata.Parameters.Eref_Update.k = 0.5;
flowdata.Parameters.Eref_Update.flag = "energy";

%Shaping Parameters
istart = find(cell2mat(grid_results.shape_length_ratio.ratio)==1.0)-1;
dim = flowdata.Parameters.dim;
i_range = [istart:-5:1,1];
i_range = [1];
for i = i_range
    ratio = grid_results.shape_length_ratio.ratio{i};

    Mh = 10;
    Ms = 5;
    Isz = 0;
    a = 0.5;
    b = a*ratio;
    params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
    params_values = {Mh, Ms, Isz, a, b, g};
    flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);

    shape_params = cell2mat(flowdata.Parameters.Shaping.values);
    flowdata.State.Eref = flowdata.E_func(fstate',shape_params);

    targetenergy = flowdata.E_func(fstate',shape_params);
    flowdata.State.Eref = targetenergy;

    disp("Shaping")
    [fstate, xout, tout, out_extra] = walk(fstate,1);
    x_total = [x_total;nan(1,dim);xout];
    t_total = [t_total;nan;tout+t_total(end)];
end
[fstate, xout, tout, out_extra] = walk(fstate,10);
x_total = [x_total;xout];
t_total = [t_total;tout+t_total(end)];

figure('Name','Positions','NumberTitle','off')
plot(t_total,rad2deg(x_total(:,3:dim/2)))
title('Joint Positions')
legend("ank","hip",'Location', 'eastoutside')
xlabel('Time (s)')
ylabel('Joint pos (deg)')
%% Shaping Parameter Change Jump
% flowdata.Controls.Internal = {@Shaping,@KPBC};
% 
% %KPBC Parameters
% flowdata.Parameters.KPBC.k = 100;
% flowdata.Parameters.KPBC.omega = diag([0,0,1,1]);
% flowdata.Parameters.KPBC.sat = inf;
% 
% %Eref update law Parameters
% flowdata.Parameters.Eref_Update.k = 0;
% flowdata.Parameters.Eref_Update.flag = "energy";
% 
% %Shaping Parameters
% i = 4;
% ratio = grid_results.shape_length_ratio.ratio{i};
% 
% Mh = 10;
% Ms = 5;
% Isz = 0;
% a = 0.5;
% b = a*ratio;
% params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
% params_values = {Mh, Ms, Isz, a, b, g};
% flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);
% 
% shape_params = cell2mat(flowdata.Parameters.Shaping.values);
% flowdata.State.Eref = flowdata.E_func(xi',shape_params);
% 
% targetspeed = grid_results.shape_length_ratio.speed{i}
% targetenergy = flowdata.E_func(grid_results.shape_length_ratio.State{i}.xi',shape_params)
% flowdata.State.Eref = targetenergy;
% 
% disp("Shaping")
% [fstate, xout, tout, out_extra] = walk(xi,25);
% disp(strcat("Expected stable speed: ", num2str(grid_results.shape_length_ratio.speed{i})))
% disp(strcat("Sim stable speed: ", num2str(out_extra.steps{end}.speed)))
% 
% b = a;
% params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
% params_values = {Mh, Ms, Isz, a, b, g};
% flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);
% 
% disp("Base Case again")
% [fstate, xout, tout, out_extra] = walk(xi,25);
% disp(strcat("Expected stable speed: ", num2str(grid_results.shape_length_ratio.speed{i})))
% disp(strcat("Sim stable speed: ", num2str(out_extra.steps{end}.speed)))