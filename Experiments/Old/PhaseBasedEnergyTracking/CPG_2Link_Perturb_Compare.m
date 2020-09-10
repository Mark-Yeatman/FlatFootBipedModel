%Uses gait sensitivity analysis to compare robustness of a passive gait,
%versus CPG, versus CPG+Phase KPBC

clear all
path(pathdef)
addpath('Experiments\PhaseBasedEnergyTracking\\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

global flowdata

flowdata = flowData;
flowdata.E_func = @TotalE_func;
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.do_validation = false;

%Parameters
g = 9.81;
Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
alpha = -3.7;

%Simulation parameters
flowdata.Parameters.Environment.slope = deg2rad(alpha); %ground slope
flowdata.Parameters.Environment.g = g;                  %gravity
flowdata.Parameters.dim = 8;                            %state variable dimension
 
%Biped Parameters
flowdata.Parameters.Biped.Mh = Mh;
flowdata.Parameters.Biped.Ms = Ms;
flowdata.Parameters.Biped.a = a;
flowdata.Parameters.Biped.b = b;
flowdata.Parameters.B = [0;0;1;0];
flowdata.Parameters.params = [Mh, Ms, Isz, a, b, g];

%Discrete Mappings and Constraints
flowdata.setPhases({'SSupp'})
impactlist =  {'FootStrike'};
n_phaselist = {'SSupp'};
n_configlist = {'keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'FootStrike';

%% Passive 
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
load('xi.mat')

[fstate, xout, tout, out_extra] = walk(xi,1);

%% CPG
%Controls 
flowdata.Controls.Internal = {@Oscillator,@KPBC_Phase};

flowdata.Parameters.Oscillator.E = 2;

flowdata.Parameters.KPBC.k = 0;
flowdata.Parameters.KPBC.omega = diag([0,0,1,0]);
flowdata.Parameters.KPBC.b = 1;

%Set initial phase, contact conditions, and state for passive gait
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
load('CPG_2Link.mat')
xi = fstate;
%ODE options 
%flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;

flowdata.Flags.do_validation = false;
flowdata.tspan = 10; 
flowdata.State = state_extra;
flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;
[fstate, xout, tout, out_extra] = walk(xi,1);

%% CPG+Phase KPBC
