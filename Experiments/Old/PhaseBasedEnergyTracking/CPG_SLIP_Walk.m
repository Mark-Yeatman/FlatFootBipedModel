clear all
path(pathdef)
addpath('Experiments\PhaseBasedEnergyTracking\\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath('Experiments\Videos\')
addpath(genpath('Models\SLIP\'))

load limit_cycle_data.mat

global flowdata

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-6, 'AbsTol', 1e-6, 'MaxStep',1e-3);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

%simulation parameters
flowdata.Parameters.Environment.slope = -deg2rad(0);    %ground slope in rads
flowdata.Parameters.dim = 4;                           %state variable dimension
 
%Biped Parameters
flowdata.Parameters.Biped = containers.Map({'m'},{70});

%Control and Parameters
flowdata.Controls.Internal = {@SpringF_func, @KPBC_SpringAxis};

flowdata.Parameters.SLIP.k = 12250;
flowdata.Parameters.SLIP.L0 = 0.94;

flowdata.Parameters.KPBC.k = 1;
flowdata.Parameters.KPBC.sat = inf;
flowdata.Parameters.KPBC.Eref = 660; %20

%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp','Flight'})
flowdata.setConfigs({})
impactlist =  {'LeadStrike','TrailRelease','FullRelease','Landing'};
e1 = struct('name','LeadStrike','nextphase','DSupp','nextconfig','');
e2 = struct('name','TrailRelease','nextphase','SSupp','nextconfig','');
e3 = struct('name','FullRelease','nextphase','Flight','nextconfig','');
e4 = struct('name','Landing','nextphase','SSupp','nextconfig','');
flowdata.Phases.SSupp.events = {e1,e3};
flowdata.Phases.DSupp.events = {e2};
flowdata.Phases.Flight.events = {e4};
flowdata.End_Step.event_name = 'LeadStrike';

%Set initial phase and contact conditions
flowdata.State.c_phase = 'DSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts()
flowdata.State.alpha = deg2rad(70); %spring impact angle 
flowdata.State.pf1 = [0.470445511451501;0];
flowdata.State.pf2 = [0;0];
xi = [0.148946576725372, 0.883311063538754, 1.130454914445423, -0.708351556462121];

[fstate, xout, tout, out_extra] = walk(xi,5);

%[fstate, xout, tout, out_extra] = walk(fstate,20);