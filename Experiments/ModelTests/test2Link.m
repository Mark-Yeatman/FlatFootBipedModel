%Tests a passive walking gait for the 2 Link compass gait biped
clear all
path(pathdef)
addpath('Experiments\ModelTests\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

global flowdata
%initial conditions and parameters from python code that is originally from
%spong?

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

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

%Constraints and Impacts
flowdata.setPhases({'SSupp'})
flowdata.setConfigs({})

e1 = struct('name','FootStrike_Slope','nextphase','SSupp','nextconfig','');
flowdata.Phases.SSupp.events = {e1};

flowdata.End_Step.event_name = 'FootStrike_Slope';
flowdata.End_Step.map = @map_End_Step;

%Set initial phase, contact conditions, and state
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts();
load('xi.mat')

%Simulate
walk(xi,3);

[fstate, xout, tout, out_extra] = walk(xi,1);

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
