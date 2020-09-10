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

% Biped Parameters
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

%Control
flowdata.Controls.Internal = {@KPBC};

flowdata.Parameters.KPBC.k = 10;
flowdata.Parameters.KPBC.omega = diag([0,0,1,1]);
flowdata.Parameters.KPBC.sat = inf;
params = cell2mat(flowdata.Parameters.Biped.values);

load xi.mat
mask = boolean([0,0,1,1,0,0,1,1]);
perturb = mask.*rand(size(xi))*1e-3;
flowdata.Parameters.KPBC.Eref = flowdata.E_func(xi',params);
[fstate, xout, tout, out_extra] = walk(xi+perturb,10);
