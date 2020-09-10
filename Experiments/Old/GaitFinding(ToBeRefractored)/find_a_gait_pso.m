global Mt Ms Mh Isz Itz lt ls                 %Mechanics parameters
global flowdata

%Load more parameters
load('MassInertiaGeometryCompass.mat')
load('xi.mat')

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
flowdata.Parameters.KPBC.omega = diag([0,0,1,1,1,1]);

%SLIP Paramerters
flowdata.Parameters.SLIP.k = 12250;
flowdata.Parameters.SLIP.L1 = 0.94;
flowdata.Parameters.SLIP.L2 = 0.94;

%Discrete Mappings 
flowdata.setPhases({'SSupp'})
flowdata.setConfigs({'KLockSt','KLockSw'})
impactlist =  {'FootStrike'};
n_phaselist = {'SSupp'};
n_configlist = {'keep'};
flowdata.setImpacts(impactlist,n_phaselist,n_configlist);
flowdata.End_Step.event_name = 'FootStrike';

%Set initial phase and contact conditions
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {'KLockSt','KLockSw'};
flowdata.State.Eref = 0;

%ODE options 
flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;

%Optimization
fun = @mycost_fmincon;

A=[];
b=[];
Aeq=[];
beq=[];

lb = -2*pi*ones(4,1); %14 parameters, x_start:12, spring:2
ub = 2*pi*ones(4,1);

ub(3) = 0;

% %spring stiffness
% lb(5) = 10000;
% ub(5) = 15000;
% %set point
% lb(6) = 0.9;
% ub(6) = 1.1;

noise(1:2) = deg2rad(1*ones(1,2));
noise(3:4) = deg2rad(4*ones(1,2));

nonlcon = @NLconst_pso;
z = [xi(3),xi(5),xi(3+6),xi(5+6)];
x0 = z+noise;

f.Aineq = [] ;
f.bineq = [] ;
f.Aeq = [] ;
f.beq = [] ;
f.LB = lb ; f.UB = ub;
f.nonlcon = nonlcon; % Could also use 'heart' or 'unitdisk'
f.options.PopInitRange = [z-noise; z+noise] ;
f.options.KnownMin = [] ;
f.options.PopulationSize = 25;
f.options.ConstrBoundary = 'penalize' ;
f.options.UseParallel = 'never';
f.options.TimeLimit = 60*5;
f.nvars = 4;
f.fitnessfcn = @mycost_fmincon;

[zout,fval,exitflag,output,population,scores] = pso(f);
xopt  = [0,0,zout(1),0,zout(2),0,0,0,zout(3),0,zout(4),0]

flowdata.Flags.silent = false;
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {'KLockSt','KLockSw'};
flowdata.State.Eref = 0;
flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;
flowdata.resetFlags();

[fstate, xout, tout, out_extra] = walk(xopt,1);
animate(xout,tout,out_extra,1/2,'test')