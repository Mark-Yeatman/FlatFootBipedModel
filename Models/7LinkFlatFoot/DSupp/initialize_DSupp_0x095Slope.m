global flowdata

flowdata = flowData;

flowdata.E_func = @MechE_func;

%Ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

%Simulation parameters
flowdata.Parameters.Environment.slope = 0.095;   %ground slope
flowdata.Parameters.dim = 16;        %state variable dimension

%Biped Parameters
flowdata.Parameters.Biped = load('MassInertiaGeometry');

%Discrete Mappings 
flowdata.setPhases({'Heel','Flat','Toe','DSupp'})
flowdata.setConfigs({})
impactlist =  {'Footslap','Tiptoe','Heelstrike','Toeoff'};
n_phaselist = {'Flat','Toe','DSupp','Heel'};
n_configlist = {'keep','keep','keep','keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'Toeoff';

%Control Functions
flowdata.Controls.Internal = {@PDControl4Phase};

%Set initial phase and contact conditions
flowdata.State.c_phase = 'Heel';
flowdata.State.c_configs = {};
flowdata.State.Eref = 0;
flowdata.odeoptions.Events = flowdata.Phases.('Heel').eventf;

%Load initial condition 
load('xi_4phaseS0x095.mat')

%Load PD control parameters
flowdata.Parameters.PD = load('PDControlParameters4Phase.mat');



