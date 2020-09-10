global Mt Ms Mh Isz Itz lt ls                 %Mechanics parameters
global flowdata

%path(pathdef)
addpath(genpath('Models\4LinkPointFoot\CompassConfig\')); 

%Load more parameters
load('MassInertiaGeometryCompassFinding.mat')
load('SLIP_Walking_Sim_outputs.mat')
xout_slipsim = xout;
ks_slipsim = ks;
L_slipsim = L;
SLIPto4Link_CordTransform %sets xa

flowdata = flowData;
flowdata.E_func = @MechE2_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.ignore = true;

%simulation parameters
flowdata.Parameters.Environment.slope = 0;%-deg2rad(3.7);   %ground slope
flowdata.Parameters.dim = 12;        %state variable dimension

%Biped Parameters
load('MassInertiaGeometryCompass','MTotal')
flowdata.Parameters.Biped.Mtotal = MTotal;

%Add Control Function
flowdata.Controls.Internal = {@SLIP};

%SLIP parameters
flowdata.Parameters.SLIP.k = ks_slipsim*MTotal/70;
flowdata.Parameters.SLIP.d = 0;
flowdata.Parameters.SLIP.L0 = L_slipsim;

%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp'})
flowdata.setConfigs({'KLockSt','KLockSw'})
impactlist =  {'FootStrike','TrailLift'};
n_phaselist = {'DSupp','SSupp'};
n_configlist = {'keep','keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'FootStrike'; %Coordinates are relabled at footstrike

%Set additional initial state and contact conditions
flowdata.Flags.silent = false;
flowdata.State.Eref = 0;
flowdata.State.c_phase = 'DSupp';
flowdata.State.c_configs = {};

flowdata.State.pf1 = [0;0];
temp = Foot_Sw_pos_func(xa');
flowdata.State.pf2 = temp(1:2,4);

flowdata.odeoptions.Events = flowdata.Phases.DSupp.eventf;
flowdata.resetFlags();



