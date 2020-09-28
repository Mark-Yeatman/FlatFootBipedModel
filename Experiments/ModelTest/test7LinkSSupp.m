clear all

path(pathdef)
addpath(genpath('Experiments'))
addpath(genpath('Analysis'))
addpath(genpath('UtilityFunctions'))
addpath('Model')
addpath(genpath('Model\SimulationFunctions'))

global flowdata

flowdata = flowData;
%flowdata.E_func = @MechE_func;

%Ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;

%Simulation Parameters
flowdata.Parameters.Environment.slope = -0.095;   %ground slope
flowdata.Parameters.dim = 16;        %state variable dimension

%Biped Parameters
flowdata.Parameters.Biped = load('MassInertiaGeometry');
load('MassInertiaGeometry');
flowdata.Parameters.Biped.asvec = [Mt Ms Mh Mf lt ls lf la Itz Ity Itx Isz Isx Isy Ihz Ihx Ihy];

%Phase Events and Mappings 
flowdata.setPhases({'Heel','Flat','Toe'})
flowdata.setConfigs({})
e1 = struct('name','HeelStrike','nextphase','Heel','nextconfig','');
e2 = struct('name','FootSlap','nextphase','Flat','nextconfig','');
e3 = struct('name','RollOntoToe','nextphase','Toe','nextconfig','');
flowdata.Phases.Toe.events = {e1};
flowdata.Phases.Heel.events = {e2};
flowdata.Phases.Flat.events = {e3};

flowdata.End_Step.event_name = 'HeelStrike';
flowdata.End_Step.map = @map_End_Step;

%Control Functions
flowdata.Controls.Internal = {@SetPoint_PD_Control};

%Extra Outputs
flowdata.PhaseOutputFuncs = {@Lambda, @event_data, @COPFootPos};
flowdata.StepOutputFuncs = {@StepLength, @Speed};
flowdata.WalkOutputFuncs = {@COMPos, @ToeSwVel, @ToeSwPos, @Energy, @SLIPSubEnergy};

%Set initial phase and contact conditions
flowdata.State.c_phase = 'Heel';
flowdata.State.c_configs = {};
flowdata.State.Eref = 0;
flowdata.setImpacts();

%Load initial condition 
load('xi.mat')
xi(3:end) = -xi(3:end);
%Load PD control parameters
flowdata.Parameters.PD = load('PDControlParameters.mat');
flowdata.Parameters.PD.setpos = -flowdata.Parameters.PD.setpos;

xtest = xi;
[fstate, xout, tout, out_extra] = walk(xtest,5);

%[fstate, xout, tout, out_extra] = walk(xtest,1);
%videopath = 'Experiments\Videos\';
%animate(@draw7Link,xout,tout,out_extra,0.2,strcat(videopath,'test7LinkSSupp'))
