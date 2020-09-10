% Test of phase based energy tracking ( where the reference energy is a
% function of the state). System is a 1-DOF Mass spring system.
path(pathdef)
addpath('Experiments\ModelTests\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\Ball\'))

global flowdata

xi = [5,0,0,0];

flowdata = flowData;
flowdata.E_func = @TotalE_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-6, 'AbsTol', 1e-6, 'MaxStep',1e-3);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;

%simulation parameters
flowdata.Parameters.dim = 4; %state variable dimension
 
%Biped Parameters
flowdata.Parameters.Biped.m = 1; %in kg

%Control and Parameters
flowdata.Controls.Internal = {@MassSpringControl, @BallKPBC};

flowdata.Parameters.Spring.k = 15;
flowdata.Parameters.Spring.L0 = 0;

flowdata.Parameters.KPBC.k = 1;
flowdata.Parameters.KPBC.omega = diag([1,0]);
%flowdata.Parameters.KPBC.Eref = TotalE_func(xi);
flowdata.Parameters.KPBC.c = TotalE_func(xi);
flowdata.Parameters.KPBC.b = 1;

%Discrete Mappings 
flowdata.setPhases({'Flight'})
flowdata.setConfigs({})
impactlist =  {};
n_phaselist = {};
n_configlist = {};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist); %note that all the constraint matrices are zero
flowdata.End_Step.event_name = '';

%Set initial phase and contact conditions
flowdata.State.c_phase = '';
flowdata.State.c_configs = {};

%ODE event initialization
flowdata.tspan = 10; %seconds
[fstate, xout, tout, out_extra] = walk(xi,1);