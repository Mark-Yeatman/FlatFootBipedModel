clear all
path(pathdef)
addpath('Experiments\EnergyShapeAndTrack_Compass\Stairs\')
addpath('UtilityFunctions\')
addpath('Analysis\Plotting\')
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
flowdata.Parameters.Environment.StairHeight = 0.037037176242425; %from goswami/spong compass gait limit cycle delta y
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

%Constraints and Impacts
flowdata.setPhases({'SSupp'})
flowdata.setConfigs({})

e1 = struct('name','FootStrike_Stairs','nextphase','SSupp','nextconfig','');
flowdata.Phases.SSupp.events = {e1};

flowdata.End_Step.event_name = 'FootStrike_Stairs';
flowdata.End_Step.map = @map_End_Step;

%Set initial phase, contact conditions, and state
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts();

%% Stairs Passive Gait, Period 2
load xi_stairs_passive_period2.mat
flowdata.State.PE_datum = xi(2);
[fstate_passive, xout_passive, tout_passive, out_extra_passive] = walk(xi,4);

%% Stairs Energy Tracking, Period 1
%Controls 
flowdata.Controls.Internal = {@KPBC};

flowdata.Parameters.KPBC.k = 10;
flowdata.Parameters.KPBC.omega = diag([0,0,1,1]);
flowdata.Parameters.KPBC.sat = inf;
params = cell2mat(flowdata.Parameters.Biped.values);

load xi.mat
flowdata.State.PE_datum = xi(2);
flowdata.Parameters.KPBC.Eref = flowdata.E_func(xi',params);

load xi_stairs_passive_period2.mat
flowdata.State.PE_datum = xi(2);
[fstate_KPBC, xout_KPBC, tout_KPBC, out_extra_KPBC] = walk(xi,10);

load xi.mat
disp("Expected fstate:")
disp(round(xi,2))

disp("Output fstate:")
disp(round(fstate_KPBC,2))
