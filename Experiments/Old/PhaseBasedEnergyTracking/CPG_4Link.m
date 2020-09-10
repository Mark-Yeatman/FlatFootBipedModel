%Test of underactuated phase based energy tracking, with a CPG oscillator
%   at the hip.

clear all
path(pathdef)
addpath('Experiments\PhaseBasedEnergyTracking\\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath('Experiments\Videos\')
addpath(genpath('Models\4LinkPointFoot\'))
addpath(genpath('Models\4LinkPointFoot\CompassConfig\')); 

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
slope = deg2rad(0); 

Mh = 70;%10;    %kg 
Mt = 2.5;   %kg 
Ms = 2.5;   %kg 
Itz = 0;    %kg m^2
Isz = 0;    %kg m^2
lt = 0.5;   %m
ls = 0.5;   %m
rt = 0.25;  %m
rs = 0.25;  %m

MTotal = Mh + 2*Mt + 2*Ms;
k = 12250;%18.03^2*Mh;%12250*Mh/70;    %N/m
d = 0;                  %N (s/m)
L0 = 0.94;              %m
c = (Mt+Ms)/Mh*0.05;
a = 0.8;

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

%Control Functions
flowdata.Controls.Internal = {@Oscillator, @SLIP, @Holonomic, @KPBC_SpringAxis};

%Oscillator Parameters 
flowdata.Parameters.Oscillator.E = 20;
flowdata.Parameters.Oscillator.k = k*c/4*2;
flowdata.Parameters.Oscillator.q0 = deg2rad(0);

%SLIP Parameters
params_keys = {'lt', 'ls', 'rt', 'rs', 'k', 'L0'};
params_values = {lt, ls, rt, rs, k, L0};
flowdata.Parameters.SLIP = containers.Map(params_keys,params_values);
flowdata.Parameters.SLIP_e.c = c;
flowdata.Parameters.SLIP_e.a = a;

%Holonomic Parameters
flowdata.Parameters.Holonomic.Kp = 0;
flowdata.Parameters.Holonomic.Kd = 0;
flowdata.Parameters.Holonomic.B = [0,0,0,0,0,1]';

%KPBC Parameters
flowdata.Parameters.KPBC.sat = inf;
flowdata.Parameters.KPBC.k = 1;
flowdata.Parameters.KPBC.Eref = 660;
                 
%Impact Mappings and Constraints
flowdata.setPhases({'SSupp','DSupp'})
flowdata.setConfigs({'KLockSt','KLockSw'})
e1 = struct('name','FootStrike','nextphase','DSupp','nextconfig','');
e2 = struct('name','TrailLift','nextphase','SSupp','nextconfig','');
e3 = struct('name','KneeLockSt','nextphase','','nextconfig','KLockSt');
e4 = struct('name','KneeLockSw','nextphase','','nextconfig','KLockSw');
e5 = struct('name','KneeUnlockSt','nextphase','','nextconfig','-KLockSt');
e6 = struct('name','KneeUnlockSw','nextphase','','nextconfig','-KLockSw');
flowdata.Phases.SSupp.events = {e1,e3,e4};
flowdata.Phases.DSupp.events = {e2,e3,e4};
flowdata.Configs.KLockSt.events = {e5};
flowdata.Configs.KLockSw.events = {e6};
flowdata.End_Step.event_name = 'FootStrike'; %This event causes the coordinates to be relabeled

%Set initial phase, contact conditions, state, ode integration time domain
hip_shift = deg2rad(-3);
ankle_vel_shift = deg2rad(180);
xi = [0         0    0.0009+slope    0.6963   -0.3692+hip_shift   -0.9375         0         0   -3.9917    6.3384   -2.3748   -2.6136];
flowdata.State.Eref = 0;

flowdata.State.c_phase = 'DSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts()
flowdata.tspan = 1.5; 

%Run Simulation
steps = 7;
[fstate, xout, tout, out_extra] = walk(xi,steps);

%Animate
videopath = 'Experiments\Videos\';
prompt_in = input("Animate?: y/n \n","s");
if strcmp(prompt_in,"y")
    animate(@draw4Link,xout,tout,out_extra,1,strcat(videopath,'CPG_4Link'))
end
