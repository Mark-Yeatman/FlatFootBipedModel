%% Initilization
clear all
path(pathdef)
addpath('Experiments\KPBC_SLIP\')
addpath(genpath('Analysis\'))
addpath('UtilityFunctions\')
addpath(genpath('Models\SLIP\'))

load flight_cycle_6x6.mat xi_flight

global flowdata
global zi

flowdata = flowData;
flowdata.E_func = @ETotal_func;

%ODE handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-12, 'AbsTol', 1e-12, 'MaxStep',1e-3);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.warnings = false;
flowdata.Flags.rigid = false;

%Simulation parameters
flowdata.Parameters.Environment.slope = deg2rad(0);    %ground slope in rads
flowdata.Parameters.dim = 4;                           %state variable dimension
 
%Biped Parameters
params = [70,9.81];
flowdata.Parameters.Biped = containers.Map({'m','g'},params);%in kg

%Control and Parameters
flowdata.Controls.Internal = {@Spring_func,@KPBC_SpringAxis};
flowdata.Parameters.SLIP.k = 30000;
flowdata.Parameters.SLIP.L0 = 0.94;

flowdata.Parameters.KPBC.k = 1; 
flowdata.Parameters.KPBC.sat = inf;

%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp','Flight'})
flowdata.setConfigs({})
impactlist =  {'LeadStrike','TrailRelease','FullRelease','Landing'};
e1 = struct('name','LeadStrike','nextphase','Failure','nextconfig','');
e2 = struct('name','TrailRelease','nextphase','SSupp','nextconfig','');
e3 = struct('name','FullRelease','nextphase','Flight','nextconfig','');
e4 = struct('name','Landing','nextphase','SSupp','nextconfig','');
flowdata.Phases.SSupp.events = {e3};
flowdata.Phases.DSupp.events = {e2};
flowdata.Phases.Flight.events = {e4};
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
flowdata.State.Eref = 2165.995;

flowdata.Parameters.KPBC.k = 0; 
zi = XYtoLTheta(xi_flight',flowdata.State.pf1);
%zi(2) = deg2rad(2) + zi(2);

e = deg2rad(10);
dtheta_search = linspace(zi(4)-e,zi(4)+e,100);
cost_search = zeros(size(dtheta_search));
for i = 1:length(dtheta_search)
    cost_search(i) = my_cost_func(dtheta_search(i));   
end

[~,i] = min(cost_search);
dtheta_guess = dtheta_search(i);
[X_STAR,FVAL,EXITFLAG,OUTPUT] = fminsearch(@my_cost_func,dtheta_guess);

%Done
play_handels_messiah

%Fmincon function
function cost = my_cost_func(dtheta)
    global zi
    global flowdata
    %z is the state vector in L,theta cords
    zi(4) = dtheta;
    flowdata.State.c_phase = 'SSupp';
    flowdata.State.c_configs = {};
    flowdata.setImpacts()
    flowdata.State.alpha =  pi - zi(2);
    flowdata.State.pf1 = [0;0];
    flowdata.State.pf2 = nan(2,1);
    xi = LThetatoXY(zi);
    params = cell2mat(flowdata.Parameters.Biped.values);
    flowdata.State.Eref = flowdata.E_func(xi, params, flowdata.State.pf1, flowdata.State.pf2);
    flowdata.Flags.silent = true;
    flowdata.Flags.terminate = false;
    flowdata.Flags.step_done = false;
    [fstate, xout, tout, out_extra] = walk(xi',1);
    %disp(fstate)
    
    if any(isnan(fstate))
        cost = 1e6;
    else
        e = zi-XYtoLTheta(fstate',flowdata.State.pf1);
        e = e(:);
        W = [1,1,0.1,0.1]';
        cost = norm(W.*e);
    end
end