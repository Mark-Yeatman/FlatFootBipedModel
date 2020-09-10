%% Setup
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
flowdata.Parameters.Biped = containers.Map({'m'},{70}); %in kg

%Control and Parameters
flowdata.Controls.Internal = {@SpringF_func,@KPBC_Combine};
flowdata.Controls.External = {@Extra_Forces};

flowdata.Parameters.KPBC.k = 1; 
flowdata.Parameters.KPBC.sat = inf;

flowdata.Parameters.KPBCx.k = 2; 
flowdata.Parameters.KPBCx.sat = inf;

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

flowdata.End_Step.map = @flowdata.identityImpact;

flowdata.tspan = 5;

%% Run
if ~flowdata.Flags.terminate
    load flight_cycle_6x6.mat xi_flight
    flowdata.Parameters.SLIP.k = 30000;
    flowdata.Parameters.SLIP.L0 = 0.94;
    flowdata.State.alpha = deg2rad(70);
    flowdata.State.pf1 = xi_flight(1:2) + flowdata.Parameters.SLIP.L0*[cos(flowdata.State.alpha),-sin(flowdata.State.alpha)];
    flowdata.State.pf1(2) = 0;
    flowdata.State.pf2 = [nan;nan];
    flowdata.Parameters.State.Eref = flowdata.E_func(xi_flight);
    flowdata.Parameters.State.Erefx = KE_func(xi_flight);
    disp("Run")
    flowdata.End_Step.event_name = 'Landing';
    %Set initial phase and contact conditions
    flowdata.State.c_phase = 'SSupp';
    flowdata.State.c_configs = {};
    flowdata.setImpacts()
    [fstate, xout, tout, out_extra] = walk(xi_flight,3);
end
%% Walk 
if ~flowdata.Flags.terminate
    flowdata.End_Step.event_name = 'LeadStrike';
    flowdata.Parameters.State.Eref = 6.824444034095972e+02;
    flowdata.Parameters.State.Erefx = 61.837007222013760;
    flowdata.State.alpha = deg2rad(70);
    flowdata.Parameters.SLIP.k = 12250;
    disp("Walk")
    [fstate, xout, tout, out_extra] = walk(fstate,10);
end

% %% Walk
% disp("Walk")
% flowdata.End_Step.event_name = 'TrailRelease';
% flowdata.Parameters.State.Eref = flowdata.E_func(xi);
% [fstate, xout, tout, out_extra] = walk(xi,3);
% 
% %% Run
% if ~flowdata.Flags.terminate
%     load flight_limit_cycle_data.mat xi_flight
%     flowdata.Parameters.State.Eref = 1.8600e+03;
%     flowdata.State.alpha = deg2rad(55);
%     flowdata.Parameters.SLIP.k = 8200;     
%     disp("Run")
%     flowdata.End_Step.event_name = 'ApexSSupp';
%     [fstate, xout, tout, out_extra] = walk(fstate,10);
% end
% %% Walk again
% if ~flowdata.Flags.terminate
%     load limit_cycle_xi.mat xi
%     flowdata.End_Step.event_name = 'TrailRelease';
%     flowdata.Parameters.State.Eref = 6.824444000000000e+02;
%     flowdata.State.alpha = deg2rad(70);
%     flowdata.Parameters.SLIP.k = 12250;
%     disp("Walk again")
%     [fstate, xout, tout, out_extra] = walk(fstate,10);
% end