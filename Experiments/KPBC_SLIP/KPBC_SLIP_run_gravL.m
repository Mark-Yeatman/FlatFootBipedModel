clear all
path(pathdef)
addpath('Experiments\KPBC_SLIP\')
addpath(genpath('Analysis\'))
addpath('UtilityFunctions\')
addpath(genpath('Models\SLIP\'))

load flight_cycle_6x6.mat xi_flight

global flowdata

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-12, 'AbsTol', 1e-12);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.warnings = false;
flowdata.Flags.rigid = false;

%simulation parameters
flowdata.Parameters.Environment.slope = deg2rad(0);    %ground slope in rads
flowdata.Parameters.dim = 4;                           %state variable dimension
 
%Biped Parameters
flowdata.Parameters.Biped = containers.Map({'m','g'},{70,9.81});%in kg

%Control and Parameters
flowdata.Controls.Internal = {@Spring_func,@Shaping_func};%,@ETrackS_func}; %{@SpringF_func,@KPBC_SpringAxis};
flowdata.Parameters.SLIP.k = 30000;
flowdata.Parameters.SLIP.L0 = 0.94;

s = 1;
flowdata.Parameters.Shaping.g = -29.0684;
flowdata.Parameters.Shaping.k = 3.9253e+04;

% flowdata.Parameters.KPBC.k = 0.0; 
% flowdata.Parameters.KPBC.sat = inf;

%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp','Flight'})
flowdata.setConfigs({})
impactlist =  {'LeadStrike','TrailRelease','FullRelease','Landing'};
e1 = struct('name','LeadStrike','nextphase','DSupp','nextconfig','');
e2 = struct('name','TrailRelease','nextphase','SSupp','nextconfig','');
e3 = struct('name','FullRelease','nextphase','Flight','nextconfig','');
e4 = struct('name','Landing','nextphase','SSupp','nextconfig','');
e6 = struct('name','Floor','nextphase','Failure','nextconfig','');
flowdata.Phases.SSupp.events = {e1,e3,e6};
flowdata.Phases.DSupp.events = {e2,e6};
flowdata.Phases.Flight.events = {e4,e6};

flowdata.End_Step.event_name = 'Landing';
flowdata.End_Step.map = @flowdata.identityImpact;

%Set initial phase and contact conditions
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.setImpacts()

flowdata.State.alpha = deg2rad(70); %spring impact angle 

flowdata.State.pf1 = xi_flight(1:2) + flowdata.Parameters.SLIP.L0*[cos(flowdata.State.alpha),-sin(flowdata.State.alpha)];
flowdata.State.pf1(2) = 0;
flowdata.State.pf1 = flowdata.State.pf1(:);
flowdata.State.pf2 = nan(2,1);
flowdata.State.Eref = SpringAxisEnergy_func(xi_flight',flowdata.State.pf1);
flowdata.State.dtheta_ref = -6.4490;

flowdata.State.A0 = 0.1290;

z = XYtoLTheta(xi_flight',flowdata.State.pf1);
deltadtheta = 1;
deltaxdot = -deltadtheta*z(1)*sin(z(2)); 
deltaydot = deltadtheta*z(1)*cos(z(2)); 
flowdata.State.z_prev = [0,deg2rad(110),0,-6.4490+deltadtheta ];
xi_flight = xi_flight + [0;0;deltaxdot;deltaydot]';
[fstate, xout, tout, out_extra] = walk(xi_flight,10);