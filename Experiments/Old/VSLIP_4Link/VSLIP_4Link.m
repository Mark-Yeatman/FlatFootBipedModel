% Embeds virtual springs between the feet and hip points of a 4-L=link point
% foot walking model. Utilizes a "virtual holonomic constraint" to place the
% swing foot in front of the stance foot (implemented through the constraint matrix AVHC).

% Not fully functional yet.

clear all
path(pathdef)
addpath('Experiments\')
addpath('Experiments\Videos')
addpath('Experiments\VSLIP_4Link\\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\4LinkPointFoot'))

global flowdata

%path(pathdef)
addpath(genpath('Models\4LinkPointFoot\CompassConfig\')); 

%Load parameters
load('MassInertiaGeometryCompassFinding.mat')
load('SLIP_Walking_Sim_outputs.mat')
xout_slipsim = xout;
ks_slipsim = ks;
L_slipsim = L;
SLIPto4Link_CordTransform %sets initial condition xa

flowdata = flowData;
flowdata.E_func = @MechE2_func;

%Ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.ignore = true;
flowdata.Flags.do_validation = false;

%Simulation parameters
%flowdata.Parameters.Environment.slope = 0;   %ground slope
alpha = 0;%-3.7;
flowdata.Parameters.Environment.slope = deg2rad(alpha);   %ground slope
xa(3) = xa(3) + deg2rad(alpha);
flowdata.Parameters.dim = 12;        %state variable dimension

%Biped Parameters
load('MassInertiaGeometryCompass','MTotal')
flowdata.Parameters.Biped.Mtotal = MTotal;

%Add Control Function
flowdata.Controls.Internal = {@SLIP,@Holonomic};

%SLIP parameters
flowdata.Parameters.SLIP.k = ks_slipsim*MTotal/70;
flowdata.Parameters.SLIP.d = 0;
flowdata.Parameters.SLIP.L0 = L_slipsim;
%flowdata.Parameters.B = [0;0;0;1;0;0];

%Holonomic Constraint Parameters
flowdata.Parameters.Holonomic.Kp = 100;
flowdata.Parameters.Holonomic.Kd = 100;
flowdata.Parameters.Holonomic.B = [0,0,1,0,0,0;
                                   0,0,0,1,0,0;
                                   0,0,0,0,1,0;
                                   0,0,0,0,0,1]';

%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp'})
flowdata.setConfigs({'KLockSt','KLockSw'})
impactlist =  {'FootStrike','TrailLift'};
n_phaselist = {'DSupp','SSupp'};
n_configlist = {'keep','keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'FootStrike'; %Coordinates are relabled at footstrike

%Set additional initial states, contact conditions, call simulation
flowdata.Flags.silent = false;

flowdata.State.Eref = 0;

flowdata.State.c_phase = 'DSupp';
flowdata.State.c_configs = {};
flowdata.odeoptions.Events = flowdata.Phases.DSupp.eventf;

flowdata.State.pf1 = [0;0];
temp = Foot_Sw_pos_func(xa');
flowdata.State.pf2 = temp(1:2,4);
flowdata.State.L0_a = flowdata.Parameters.SLIP.L0;
flowdata.State.L0_b = flowdata.Parameters.SLIP.L0; 

flowdata.resetFlags();
[fstate, xout, tout, out_extra] = walk(xa,2);

videopath = 'Experiments\Videos\';
animate(@draw4Link,xout,tout,out_extra,1,strcat(videopath,'test_SLIP_in_4Link'))