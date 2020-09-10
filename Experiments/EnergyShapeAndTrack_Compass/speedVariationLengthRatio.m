%Demonstrates changing walking speeds in the 2 Link compass gait biped through shaping the
%length ratio between the shank and hip masses. Uses an adaptive energy
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

%Biped Parameters
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

%Shaping Parameters
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);

%KPBC Parameters
flowdata.Parameters.KPBC.k = 100;
flowdata.Parameters.KPBC.omega = diag([0,0,1,0.1]);
flowdata.Parameters.KPBC.sat = inf;

%Eref update law Parameters
flowdata.Parameters.Eref_Update.k = 0.5;

%Add Control Function
flowdata.Controls.Internal = {@Shaping, @KPBC};

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
load('xi.mat')
shape_params = cell2mat(flowdata.Parameters.Shaping.values);
flowdata.State.Eref = flowdata.E_func(xi',shape_params);

xout_all = [];
tout_all = [];
out_extra_all = {};

load('C:\Users\Mark\Box Sync\Research\StandardizedSimCode\Experiments\EnergyShapeAndTrack_Compass\Data\grid_results.mat')

b = a*grid_results.shape_length_ratio_epbc_ball.ratio{1};
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);
shape_params = cell2mat(flowdata.Parameters.Shaping.values);
%flowdata.State.Eref = flowdata.E_func(fstate',shape_params);

xi = grid_results.shape_length_ratio_epbc_ball.State{1}.xi;
flowdata.State = grid_results.shape_length_ratio_epbc_ball.State{1}.extra;
[fstate, xout, tout, out_extra] = walk(xi,10);

%% TO DO
% %Run passive gait for 3 steps
% [fstate, xout, tout, out_extra] = walk(xi,3);
% xout_all = [xout_all;xout];
% tout_all = [tout_all,tout];
% out_extra_all{1} = out_extra;
% 
% %Run 0.75 ratio gait, "fast walking", for 10 steps
% b = a*0.75;
% params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
% params_values = {Mh, Ms, Isz, a, b, g};
% flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);
% shape_params = cell2mat(flowdata.Parameters.Shaping.values);
% flowdata.State.Eref = flowdata.E_func(fstate',shape_params);
% 
% [fstate, xout, tout, out_extra] = walk(fstate,10);
% xout_all = [xout_all;xout];
% tout_all = [tout_all;tout];
% out_extra_all{2} = out_extra;

% %Transition back to passive gait
% b = a;
% params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
% params_values = {Mh, Ms, Isz, a, b, g};
% flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);
% 
% [fstate, xout, tout, out_extra] = walk(fstate,10);
% xout_all = [xout_all;xout];
% tout_all = [tout_all;tout];
% out_extra_all{3} = out_extra;
