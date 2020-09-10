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

Eref = 1;

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
flowdata.Controls.Internal = {@SLIP_Test};

%SLIP Parameters
params_keys = {'lt', 'ls', 'rt', 'rs', 'k', 'L0'};
params_values = {lt, ls, rt, rs, k, L0};
flowdata.Parameters.SLIP = containers.Map(params_keys,params_values);
flowdata.Parameters.SLIP_e.Eref = Eref;
               
%Impact Mappings and Constraints
flowdata.setPhases({'DoublePendulum'})
flowdata.setConfigs({})

%Set initial phase, contact conditions, state, ode integration time domain
hip_shift = deg2rad(-3);
ankle_vel_shift = deg2rad(180);
xi = [0, 0, -pi/2, 0, pi/2 + pi/16, -pi/16,...
      0, 0, 0, 0, 8.224, 0];
flowdata.State.Eref = 0;

flowdata.State.c_phase = 'DoublePendulum';
flowdata.State.c_configs = {};
flowdata.tspan = 1.5; 

%Run Simulation
steps = 1;
[fstate, xout, tout, out_extra] = walk(xi,steps);

%Animate
videopath = 'Experiments\Videos\';
prompt_in = input("Animate?: y/n \n","s");
if strcmp(prompt_in,"y")
    animate(@draw4Link,xout,tout,out_extra,1,strcat(videopath,'CPG_4Link'))
end
