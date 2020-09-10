clear all
path(pathdef)
addpath(genpath('Experiments\EnergyShapeAndTrack_Compass\'))
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

e1 = struct('name','FootStrike_Slope','nextphase','SSupp','nextconfig','');
e2 = struct('name','FallForward','nextphase','Failure','nextconfig','');
e3 = struct('name','FallBackward','nextphase','Failure','nextconfig','');
flowdata.Phases.SSupp.events = {e1,e2,e3};

flowdata.End_Step.event_name = 'FootStrike_Slope';
flowdata.End_Step.map = @map_End_Step;

%Set initial phase, contact conditions, and state
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts();

load('Data\grid_results.mat')

%% Physical Parameter Change
ratio = grid_results.physical_mass_ratio.ratio{end-1};
StateStart = grid_results.physical_mass_ratio.State{end-1}.extra;
xi = grid_results.physical_mass_ratio.State{end-1}.xi;

Ms = 5;
Mh = Ms * ratio;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

flowdata.State = StateStart;
disp("Physical parameter test")
[fstate_a, xout_a, tout_a, out_extra_a] = walk(xi,1);
disp(strcat("Expected stable speed: ", num2str(grid_results.physical_mass_ratio.speed{end-1})))
disp(strcat("Sim stable speed: ", num2str(out_extra_a.steps{end}.speed)))
Mtotal = 2*Ms + Mh;
COT_a = cost_of_transport(xout_a,out_extra_a.u,tout_a,Mtotal,g,out_extra_a.steps{1}.steplength);
disp(strcat("Cost of Transport: ", num2str(COT_a)))
%% Shaping Parameter Change
flowdata.Controls.Internal = {@Shaping,@KPBC};

%KPBC Parameters
flowdata.Parameters.KPBC.k = 1;
flowdata.Parameters.KPBC.omega = diag([0,0,1,1]);
flowdata.Parameters.KPBC.sat = inf;
flowdata.Parameters.Eref_Update.flag = '';

%Eref update law Parameters
flowdata.Parameters.Eref_Update.k = 0.5;

%Shaping Parameters
ratio = grid_results.shape_mass_ratio.ratio{end-1};
StateStart = grid_results.shape_mass_ratio.State{end-1}.extra;
xi = grid_results.shape_mass_ratio.State{end-1}.xi;

Ms = 5;
Mh = Ms * ratio;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);

% Biped Parameters
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

flowdata.State = StateStart;
shape_params = cell2mat(flowdata.Parameters.Shaping.values);
flowdata.State.Eref = flowdata.E_func(xi',shape_params);
disp(" ")
disp("Shape parameter test")
[fstate, xout, tout, out_extra] = walk(xi,1);
disp(strcat("Expected stable speed: ", num2str(grid_results.shape_mass_ratio.speed{end-1})))
disp(strcat("Sim stable speed: ", num2str(out_extra.steps{end}.speed)))
COT_b = cost_of_transport(xout,out_extra.u,tout,Mtotal,g,out_extra.steps{1}.steplength);
disp(strcat("Cost of Transport: ", num2str(COT_b)))