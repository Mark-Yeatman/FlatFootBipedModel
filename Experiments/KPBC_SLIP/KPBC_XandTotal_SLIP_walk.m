clear all
path(pathdef)
addpath('Experiments\KPBC_SLIP\')
addpath(genpath('Analysis\'))
addpath('UtilityFunctions\')
addpath(genpath('Models\SLIP\'))

load limit_cycle_xi.mat xi

global flowdata

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-6, 'AbsTol', 1e-6, 'MaxStep',1e-3);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.warnings = false;
flowdata.Flags.rigid = false;

%simulation parameters
flowdata.Parameters.Environment.slope = deg2rad(0);    %ground slope in rads
flowdata.Parameters.dim = 4;                           %state variable dimension
 
%Biped Parameters
flowdata.Parameters.Biped = containers.Map({'m'},{70});%in kg

%Control and Parameters
flowdata.Controls.Internal = {@SpringF_func,@KPBC_SpringAxis,@KPBC_X_Onto_SpringAxis};
flowdata.Controls.External = {@Extra_Forces,@KPBC_SpringAxis};
flowdata.Parameters.SLIP.k = 12250;
flowdata.Parameters.SLIP.L0 = 0.94;

flowdata.Parameters.KPBC.k = 0.1; 
flowdata.Parameters.KPBC.sat = inf;

flowdata.Parameters.KPBCx.k = 0.1; 
flowdata.Parameters.KPBCx.sat = inf;

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
flowdata.End_Step.map = @flowdata.identityImpact;

%Set initial phase and contact conditions
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts()
flowdata.State.alpha = deg2rad(70); %spring impact angle 
flowdata.State.pf1 = [0.1251;0];
flowdata.State.pf2 = [nan;nan];

flowdata.Parameters.State.Eref = flowdata.E_func(xi);
flowdata.Parameters.State.Erefx = KE_func(xi);
perturb = 0*[0;0;0.1;0.1];
[fstate, xout, tout, out_extra] = walk(xi+perturb',9);