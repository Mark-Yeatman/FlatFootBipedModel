clear all

path(pathdef)
addpath(genpath('Experiments'))
addpath(genpath('Analysis'))
addpath(genpath('UtilityFunctions'))
addpath('Model')
addpath(genpath('Model\SimulationFunctions'))

global flowdata

flowdata = flowData;
flowdata.E_func = @MechE_func;

%Ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;

%Simulation Parameters
flowdata.Parameters.Environment.slope = 0;   %ground slope
flowdata.Parameters.dim = 16;        %state variable dimension

%Biped Parameters
flowdata.Parameters.Biped = load('MassInertiaGeometry');
load('MassInertiaGeometry');
flowdata.Parameters.Biped.asvec = [Mt Ms Mh Mf lt ls lf la Itz Ity Itx Isz Isx Isy Ihz Ihx Ihy];

%Control innput mapping matrix
flowdata.Parameters.B = eye(8,8);
flowdata.Parameters.B = flowdata.Parameters.B(:,4:8);

%Phase Events and Mappings 
flowdata.setPhases({'Flat'})
flowdata.setConfigs({})
flowdata.Phases.Flat.events = {};

%Control Functions
flowdata.Controls.Internal = {@Force_Control};
flowdata.Parameters.Cntr.k = 6867*.8;
flowdata.Parameters.Cntr.d = 10;
flowdata.Parameters.Cntr.L0 = 0.70;

%Extra Outputs
flowdata.PhaseOutputFuncs = {@Lambda, @event_data, @COPFootPos};
flowdata.StepOutputFuncs = {@StepLength, @Speed};
flowdata.WalkOutputFuncs = {@COMPos, @ToeSwVel, @ToeSwPos, @Energy, @SLIPSubEnergy};

%Set initial phase and contact conditions
flowdata.State.c_phase = 'Flat';
flowdata.State.c_configs = {};
flowdata.State.Eref = 0;
flowdata.setImpacts();

%Load initial condition 
xi = deg2rad([0,0,0,-15,15,-5,5,10,0,0,0,0,0,0,0,0]);
flowdata.tspan = 1;
[fstate, xout, tout, out_extra] = walk(xi,1);

%videopath = 'Experiments\Videos\';
%animate(@draw7Link,xout,tout,out_extra,1,strcat(videopath,'testForceCntr'))
basicplots7Link;