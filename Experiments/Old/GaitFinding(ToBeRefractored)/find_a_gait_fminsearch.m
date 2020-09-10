global Mt Ms Mh Isz Itz lt ls                 %Mechanics parameters
global flowdata sw_knee_ang

%path(pathdef)
addpath('SLIPConfig\SimulationFunctions\DynamicsFunctions'); 
addpath('SLIPConfig\SimulationFunctions\ConstraintFunctions'); 
addpath('SLIPConfig\SimulationFunctions\ControlFunctions'); 
addpath('SLIPConfig\SimulationFunctions\ImpactFunctions'); 
addpath('SLIPConfig\SimulationFunctions\EnergyFunctions'); 
addpath('SLIPConfig\UtilityFunctions'); 
addpath('SLIPConfig\AnalysisFunctions'); 
addpath('SLIPConfig\SimulationFunctions\KinematicFunctions')

%Load more parameters
load('MassInertiaGeometryCompassFinding.mat')
load('xopt.mat')

flowdata = flowData;
flowdata.E_func = @MechE2_func;
%ode equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = true;
flowdata.Flags.ignore = true;

%simulation parameters
flowdata.Parameters.Environment.slope = -deg2rad(3.7);   %ground slope
flowdata.Parameters.dim = 12;        %state variable dimension

%PBC parameters
flowdata.Parameters.KPBC.sat = inf;
flowdata.Parameters.KPBC.k = 0;
flowdata.Parameters.KPBC.omega = diag([0,0,1,0,1,0]);

%SLIP parameters
flowdata.Parameters.SLIP.ks = 12250;
flowdata.Parameters.SLIP.kd = flowdata.Parameters.SLIP.ks*0.5;

% %Discrete Mappings 
% flowdata.setPhases({'SSupp','DSupp'})
% flowdata.setConfigs({'KLockSt','KLockSw'})
% impactlist =  {'FootStrike','TrailLift'};
% n_phaselist = {'DSupp','SSupp'};
% n_configlist = {'keep','keep'};
% flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
% flowdata.End_Step.event_name = 'TrailLift';

%Discrete Mappings 
flowdata.setPhases({'SSupp'})
flowdata.setConfigs({'KLockSt','KLockSw'})
impactlist =  {'FootStrike'};
n_phaselist = {'SSupp'};
n_configlist = {'keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'FootStrike';

%Set initial phase and contact conditions
%Discrete Mappings 
flowdata.setPhases({'SSupp','DSupp'})
flowdata.setConfigs({'KLockSt','KLockSw'})
impactlist =  {'FootStrike','TrailLift'};
n_phaselist = {'DSupp','SSupp'};
n_configlist = {'keep','keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'TrailLift';


%Optimization
fun = @mycost_fminsearch;

x_init = xopt_new1;
%x_init(4) = x_init(4) + deg2rad(10);
%x_init(6) = x_init(6) + deg2rad(-10);;
sw_knee_ang = x_init(6);

flowdata.Parameters.SLIP.L1 = L1_func(x_init');
flowdata.Parameters.SLIP.L2 = L1_func(x_init');

z = [x_init(3:6),x_init(3+6:6+6)];
x0 = z;

options = optimset(@fminsearch);
options.PlotFcn = 'optimplotfval';
options.TolFun = 1e-5;
options.TolX = 1e-5;
tic;
%turn off dumb warnings
%w = warning();
%warning('off', 'Warning: Matrix is singular, close to singular or badly scaled. Results may be inaccurate. RCOND = NaN.')
[zout,objval,exitflag] = fminsearch(fun,x0,options);
%warning(w);
xopt_new  = [0,0,zout(1:4),0,0,zout(5:8)]
toc;

flowdata.Flags.silent = false;
flowdata.State.Eref = 4.109099740081765e+02;
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {};
flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;
flowdata.resetFlags();

input('Press enter to see animation')
[fstate, xout, tout, out_extra] = walk(xopt_new,2);
animate(xout,tout,out_extra,1/2,'test')