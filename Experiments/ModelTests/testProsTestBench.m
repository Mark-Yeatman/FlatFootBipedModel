%clear all
path(pathdef)
addpath('Experiments\ModelTests\')
addpath('Analysis\')
addpath('UtilityFunctions\')

%Get all the simulations functions
addpath(genpath('Models\Prosthesis\TestBench'))

global flowdata
flowdata = flowData;

flowdata.E_func = @E_func;

%Ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-5, 'AbsTol', 1e-5);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

%Simulation parameters
flowdata.Parameters.Environment.slope = 0;   %ground slope
dim = 10;
flowdata.Parameters.dim = dim;                 %state variable dimension

%Dynamics Parameters, from Leg 2 Overview.docx
Mt = 6;
Ms = 6.991429/2.205; % converted to kg
Mf = 0.55 + 1.643130/2.205; %carbon fiber foot + mechanism, kg
lt = 0.3733; %0.0959; %meters
ls = 0.3733; %meters
la = 0.0628; %meters
lf = 0.1; %meters
px = 0; %meters
py = 0; %meters
flowdata.Parameters.Dynamics.asvector = [Mt, Ms, Mf, lt, ls, la, lf, px, py]; %From ordering in makeMatlabFunctionsProthesisTestBench
%px, py is hip side spring mount point, other is the toe

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
xi = zeros(1,dim);
x_E_min = [0, 0, -0.000000052891209, -0.873702184821549, 0, 0, 0, 0];
perturb = [0, 0, -0.1, -0.1 , 0, 0, 0, 0];
E_min = -15.371619960146401;
%Control Functions
%flowdata.Controls.Internal = {@SLIP, @KPBC};
%flowdata.Controls.Internal = {@PD};
flowdata.Controls.Internal = {@SLIP, @HardStops, @PD, @Shaping};
flowdata.Controls.External = {@KPBC};

%Control Parameters
flowdata.Parameters.PD.KD = [0.4169;0.4169]; %emulates physical damping
flowdata.Parameters.PD.KP = [0;0];
flowdata.Parameters.PD.setpoint = [0;0];

flowdata.Parameters.Hardstops.KD = [0.25;0.25];
flowdata.Parameters.Hardstops.KP = [10;10];
flowdata.Parameters.Hardstops.lower_limits = deg2rad([-100; -25]);
flowdata.Parameters.Hardstops.upper_limits = deg2rad([-2; 25]);

flowdata.Parameters.SLIP.L0 = 0.5088;
flowdata.Parameters.SLIP.k = 1000; 
flowdata.Parameters.SLIP.d = 0;

flowdata.Parameters.KPBC.k = 5;
flowdata.Parameters.KPBC.omega = diag([0,0,0,1,1]);
flowdata.Parameters.KPBC.sat = 100;
flowdata.Parameters.KPBC.Eref = 5;

flowdata.Parameters.Shaping.shift = deg2rad(45);

%flowdata.E_func = @Energy_Sub;
flowdata.Flags.do_validation = false;

flowdata.tspan = 5;
xtest = deg2rad([0,0,0,-45,0,  0,0,0,-1,1]');
flowdata.Parameters.SLIP.L0  = Spring_Length_func(xtest,flowdata.Parameters.Dynamics.asvector);
[fstate, xout, tout, out_extra] = walk(xtest',1);

videopath = 'Experiments\Videos\';
%animate(@drawProsthesisTestBench,xout,tout,[],1,strcat(videopath,'testProsTestBench_OpenLoop'))
%animate(@drawProsthesisTestBench,xout,tout,[],1)