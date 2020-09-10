path(pathdef)
addpath('Experiments\KPBC_SLIP\')
addpath(genpath('Analysis\'))
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
flowdata.Parameters.Biped = containers.Map({'m'},{70});%in kg

%Control and Parameters
flowdata.Controls.Internal = {@SpringF_func,@KPBC_SpringAxis};
flowdata.Parameters.SLIP.k = 12250;
flowdata.Parameters.SLIP.L0 = 0.94;

flowdata.Parameters.KPBC.k = 0.1; 
flowdata.Parameters.KPBC.sat = inf;

flowdata.Parameters.attack_angle.k = 50;

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

fstate = xi_flight;
flowdata.State.Eref = flowdata.E_func(fstate);
flowdata.State.s = 0.3131;
E_target = [flowdata.State.Eref,flowdata.State.Eref*0.6];%flowdata.State.Eref:-100:flowdata.State.Eref*0.5;
k_target = [12250,12250*1.5];%12250:100:12250*1.2;

for i=1:length(k_target)
    flowdata.Parameters.SLIP.k = k_target(i);
    flowdata.State.Eref = E_target(i);
    [fstate, xout, tout, out_extra] = walk(fstate,90);
    if flowdata.Flags.terminate
       break; 
    end
end