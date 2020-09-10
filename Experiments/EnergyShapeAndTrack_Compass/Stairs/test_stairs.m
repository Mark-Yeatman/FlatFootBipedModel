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

% This initial condition is from the biped with the same parameters except
% on a slope instead of stairs. The stair height is the deltay from that
% limit cycle. 
%
% For the stairs xi is on an unstable limit cycle that bifurcates into a 
% stable period-2 gait versus the stable period 1 gait on the slope. 
load('xi.mat')
mask = boolean([0,0,1,1,0,0,1,1]);
xi = mask.*xi;

%Simulate unstable gait on stairs for 5 steps
walk(xi,5);

%Perturb and let converge to period 2
flowdata.Flags.silent = true;
perturb = mask.*rand(size(xi))*1e-3;
[fstate, ~, ~, ~] = walk(xi+perturb,50);

%Simulate period 2 gait
flowdata.Flags.silent = false;
[fstate, xout, tout, out_extra] = walk(fstate,4);

%Look at the results
videopath = 'Experiments\Videos\';
prompt_in = input("Animate?: y/n \n","s");
if strcmp(prompt_in,"y")
    addpath('Analysis\Drawing\')
    animate(@draw2Link,xout,tout,out_extra,1,strcat(videopath,'test2Link'))
end

prompt_in = input("Plots?: y/n \n","s");
if strcmp(prompt_in,"y")
    addpath('Analysis\Plotting\')
    basicplots2Link
end
