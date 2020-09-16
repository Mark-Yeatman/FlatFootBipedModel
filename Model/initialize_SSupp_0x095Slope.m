%Uses most of the same double support functions and code.
%Changes the: 
% Discrete Mapping in the flowdata object
% Some of the constraint functions

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
flowdata.setPhases({'Heel','Flat','Toe'})
flowdata.setConfigs({})
e1 = struct('name','HeelStrike','nextphase','Heel','nextconfig','');
e2 = struct('name','FootSlap','nextphase','Flat','nextconfig','');
e3 = struct('name','Toe','nextphase','Toe','nextconfig','');
flowdata.Phases.Toe.events = {e1};
flowdata.Phases.Heel.events = {e2};
flowdata.Phases.Flat.events = {e3};

flowdata.End_Step.event_name = 'HeelStrike';
flowdata.End_Step.map = @map_End_Step;

%Control Functions
flowdata.Controls.Internal = {@PDControl4Phase};

%Set initial phase and contact conditions
flowdata.State.c_phase = 'Heel';
flowdata.State.c_configs = {};
flowdata.State.Eref = 0;
flowdata.setImpacts();

%Load initial condition 
load('xi.mat')
xi
%Load PD control parameters
flowdata.Parameters.PD = load('PDControlParameters.mat');


