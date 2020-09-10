clear all
path(pathdef)
addpath('Experiments\ModelTests\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\4LinkPointFoot'))

global flowdata
flowdata = flowData;

%ODE equation handle and tolerances
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.do_validation = false;

%Parameters
g = 9.81;   %m/(kg s^2)
slope = deg2rad(-3.7); 

Mh = 10;    %kg 
Mt = 2.5;   %kg 
Ms = 2.5;   %kg 
Itz = 0;    %kg m^2
Isz = 0;    %kg m^2
lt = 0.5;   %m
ls = 0.5;   %m
rt = 0.01;  %m
rs = 0.49;  %m

%Environment Parameters
flowdata.Parameters.Environment.slope = slope; %ground slope
flowdata.Parameters.Environment.g = g;
flowdata.Parameters.dim = 12;        %state variable dimension
 
%Biped Parameters
params_keys = {'Mh', 'Mt', 'Ms', 'Itz', 'Isz', 'lt', 'ls', 'rt', 'rs', 'g'};
params_values = {Mh, Mt, Ms, Itz, Isz, lt, ls, rt, rs, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

%Energy Function
flowdata.E_func = @MechE_func;

%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp'})
flowdata.setConfigs({'KLockSt','KLockSw'})
impactlist =  {'FootStrike'};
n_phaselist = {'SSupp'};
n_configlist = {'keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'FootStrike';

%Set initial phase and contact conditions
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {'KLockSt','KLockSw'};
flowdata.State.Eref = 0;
flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;

%Load initial condition
load('xi.mat')

[fstate, xout, tout, out_extra] = walk(xi,3);

videopath = 'Experiments\Videos\';
prompt_in = input("Animate?: y/n \n","s");
if strcmp(prompt_in,"y")
    animate(@draw4Link,xout,tout,out_extra,1,strcat(videopath,'test4Link'))
end