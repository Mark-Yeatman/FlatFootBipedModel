clear all
path(pathdef)
addpath('Experiments\KPBC_SLIP\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\SLIP\'))

load flight_limit_cycle_data.mat xi_flight

global flowdata

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.warnings = false;
flowdata.Flags.rigid = false;

%simulation parameters
flowdata.Parameters.Environment.slope = deg2rad(0);    %ground slope in rads
flowdata.Parameters.dim = 4;                           %state variable dimension
 
%Biped Parameters
flowdata.Parameters.Biped = containers.Map({'m'},{70}); %in kg

%Control and Parameters
flowdata.Controls.Internal = {@SpringF_func, @KPBC_SpringAxis};

flowdata.Parameters.SLIP.k = 8200;
flowdata.Parameters.SLIP.L0 = 1;

flowdata.Parameters.KPBC.k = 0; 
flowdata.Parameters.KPBC.sat = inf;

flowdata.Parameters.attack_angle.k = -10;

%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp','Flight'})
flowdata.setConfigs({})
impactlist =  {'LeadStrike','TrailRelease','FullRelease','Landing'};
e1 = struct('name','LeadStrike','nextphase','DSupp','nextconfig','');
e2 = struct('name','TrailRelease','nextphase','SSupp','nextconfig','');
e3 = struct('name','FullRelease','nextphase','Flight','nextconfig','');
e4 = struct('name','Landing','nextphase','SSupp','nextconfig','');
e5 = struct('name','ApexFlight','nextphase','Flight','nextconfig','');
e6 = struct('name','Floor','nextphase','Failure','nextconfig','');
flowdata.Phases.SSupp.events = {e1,e3,e6};
flowdata.Phases.DSupp.events = {e2,e6};
flowdata.Phases.Flight.events = {e4,e5,e6};

flowdata.End_Step.event_name = 'Landing';
flowdata.End_Step.map = @flowdata.identityImpact;

%Set initial phase and contact conditions
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts()

flowdata.State.alpha = deg2rad(55); %spring impact angle 
flowdata.State.pf1 = xi_flight(1:2) + flowdata.Parameters.SLIP.L0*[cos(flowdata.State.alpha),-sin(flowdata.State.alpha)];
flowdata.State.pf1(2) = 0;
flowdata.State.pf2 = nan;

flowdata.State.Eref = flowdata.E_func(xi_flight);
flowdata.State.s = 0.3131;
perturb = 0.01*[1,1,1,1];
[fstate, xout, tout, out_extra] = walk(xi_flight+perturb,20);