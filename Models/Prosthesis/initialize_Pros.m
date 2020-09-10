%Uses most of the same double support functions and code.
%Changes the: 
% Discrete Mapping in the flowdata object
% Some of the constraint functions

global flowdata

flowdata = flowData;

flowdata.E_func = @SLIP_E_func;

%Ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

%Simulation parameters
flowdata.Parameters.Environment.slope = 0;   %ground slope
flowdata.Parameters.dim = 10;        %state variable dimension

%Biped Parameters
flowdata.Parameters.Biped = load('MassInertiaGeometry');
load('MassInertiaGeometry')
flowdata.Parameters.Biped.asvector = [Mh, Mt, Ms, Mf, Ihz, Itz, Isz, lt, ls, la, lf]; %From ordering in makeMatlabFunctionsProthesis

%Discrete Mappings and Constraints
flowdata.setPhases({})
flowdata.setConfigs({'Mounted'})
impactlist =  {};
n_phaselist = {};
n_configlist = {'Mounted'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = '';

%Set initial phase and contact conditions
flowdata.State.c_phase = {};
flowdata.State.c_configs = {'Mounted'};
flowdata.State.Eref = 0;
flowdata.odeoptions.Events = [];
flowdata.tspan = 5; %5 seconds of in simulation time

%Load initial condition 
xi = zeros(1,10);



