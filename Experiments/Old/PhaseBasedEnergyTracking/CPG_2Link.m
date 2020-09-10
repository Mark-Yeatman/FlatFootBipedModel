%Test of underactuated phase based energy tracking, with a CPG oscillator
%at the hip.

clear all
path(pathdef)
addpath('Experiments\PhaseBasedEnergyTracking\\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

global flowdata

steps = 10;

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

%Parameters
g = 9.81;
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;

load('CPG_2Link_3x7d.mat')
xi = fstate;
%simulation parameters
flowdata.Parameters.Environment.slope = -deg2rad(0); %ground slope
flowdata.Parameters.Environment.g = g;
flowdata.Parameters.dim = 8;        %state variable dimension
 
%Biped Parameters
%Biped Parameters
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

%Controls
flowdata.Controls.Internal = {@Oscillator};%,@KPBC_Phase};

%Oscillator
flowdata.Parameters.Oscillator.E = 4;
flowdata.Parameters.Oscillator.k = 0.1;
flowdata.Parameters.Oscillator.q0 = 0;

%KPBC
flowdata.Parameters.KPBC.k = 0.1;
flowdata.Parameters.KPBC.omega = diag([0,0,1,1]);
flowdata.Parameters.KPBC.B = [0,0,1,0]';

%Discrete Mappings and Constraints
flowdata.setPhases({'SSupp'})
flowdata.setConfigs({});
e1 = struct('name','FootStrike','nextphase','SSupp','nextconfig','');
flowdata.Phases.SSupp.events = {e1};
flowdata.End_Step.event_name = 'FootStrike';

%Set initial phase, contact conditions, and state
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};

%ODE options 
%flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;

flowdata.Flags.do_validation = false;
flowdata.tspan = 10; 
flowdata.setImpacts()
xi(2) = 0;
[fstate, xout, tout, out_extra] = walk(xi,steps);
videopath = 'Experiments\Videos\';
prompt_in = input("Animate?: y/n \n","s");
if strcmp(prompt_in,"y")
    animate(@draw2Link,xout,tout,out_extra,1,strcat(videopath,'test2LinkErefPhase'))
end
