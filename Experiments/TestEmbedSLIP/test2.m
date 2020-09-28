clear vars
path(pathdef)
addpath(genpath('Experiments\TestEmbedSLIP'))
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
flowdata.Flags.ignore = true;

%Simulation parameters
flowdata.Parameters.Environment.slope = 0;   %ground slope
flowdata.Parameters.dim = 16;        %state variable dimension

%Biped Parameters
flowdata.Parameters.Biped = load('MassInertiaGeometry.mat');
load('MassInertiaGeometry.mat');
lt = 0.5;
ls = 0.5;
flowdata.Parameters.Biped.asvec = [Mt Ms Mh Mf lt ls lf la Itz Ity Itx Isz Isx Isy Ihz Ihx Ihy];
params = flowdata.Parameters.Biped.asvec;
flowdata.Parameters.B = eye(8,8);
flowdata.Parameters.B = flowdata.Parameters.B(:,3:8);

%Phase Mappings 
flowdata.setPhases({'Heel','Flat','Toe','DSuppToeHeel','DSuppToeFlat','Flight'})
flowdata.setConfigs({})
e1 = struct('name','HeelStrike','nextphase','DSuppToeHeel','nextconfig','');
e2 = struct('name','FootSlap','nextphase','Flat','nextconfig','');
e3 = struct('name','RollOntoToe','nextphase','Toe','nextconfig','');
e4 = struct('name','TrailLift','nextphase','Heel','nextconfig','');

e5 = struct('name','FootSlap','nextphase','DSuppToeFlat','nextconfig','');
e6 = struct('name','TrailLift','nextphase','Flat','nextconfig','');

flowdata.Phases.Heel.events = {};
flowdata.Phases.Flat.events = {};
flowdata.Phases.Toe.events = {};

flowdata.Phases.DSuppToeHeel.events = {};
flowdata.Phases.DSuppToeFlat.events = {};
flowdata.Phases.Flight.events = {};

flowdata.End_Step.event_name = 'RollOntoToe';
flowdata.End_Step.map = @map_End_Step;

%Control Functions
flowdata.Controls.Internal = {};%{@SLIP_Control2};

flowdata.Controls.External = {@ToeConstraint};

flowdata.Parameters.SLIP.k = 12250;
flowdata.Parameters.SLIP.L0 = 0.94;
flowdata.Parameters.SLIP.d = 1;
flowdata.Parameters.SLIP.Md = 70;

flowdata.Parameters.CONSTR.k = 1000;
flowdata.Parameters.CONSTR.d = 1000;

flowdata.Parameters.COP_Clock.period = 0.4108*0.05;

flowdata.Parameters.KPBC.kappa = 1;

%Extra Outputs
flowdata.PhaseOutputFuncs = {@Lambda, @event_data, @COPFootPos};
flowdata.StepOutputFuncs = {@StepLength, @Speed};
flowdata.WalkOutputFuncs = {@HipPos,@ToeSwPos,@ToeSwVel};

%Set initial phase and contact conditions
flowdata.State.c_phase = 'Toe';
flowdata.State.c_configs = {};
flowdata.State.Eref = 0;
flowdata.setImpacts();

%Load initial condition 
load('xi_slip_dsupp.mat');
dim = 16;
flowdata.tspan = 1;
flowdata.Flags.warnings = false;
xi_slip_dsupp(9:16)=0;
R = [zeros(1,dim/2);
             zeros(1,dim/2);
             0,0,ones(1,dim/2-2);[zeros(dim/2-3,3),flip(-1*eye(dim/2-3),1)]];
xi_slip_dsupp(1:8) = (R*xi_slip_dsupp(1:8)')';
[fstate, xout, tout, out_extra] = walk(xi_slip_dsupp,1);

toe_p_vel= Toe_Sw_vel_func(xi_slip_dsupp',params);
toe_vel = toe_p_vel(1:2,4)