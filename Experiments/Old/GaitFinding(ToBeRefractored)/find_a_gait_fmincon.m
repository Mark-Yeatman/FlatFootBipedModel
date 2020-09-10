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

nonlcon = @NLconst_fmincon;
z = [xi(3),xi(5),xi(3+6),xi(5+6)];
x0 = z;

options = optimoptions(@fmincon);
options.Algorithm = 'interior-point'; %i've tried, sqp and active set, they are somewhat less effective
options.PlotFcn = 'optimplotfval';
options.ConstraintTolerance = 1e-4;
tic;
%turn off dumb warnings
w = warning();
warning('off', 'Warning: Matrix is singular, close to singular or badly scaled. Results may be inaccurate. RCOND = NaN.')

[zout,objval,exitflag] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
warning(w);
xopt  = [0,0,zout(1),0,zout(2),0,0,0,zout(3),0,zout(4),0]
toc;

flowdata.Flags.silent = false;
flowdata.State.c_phase = 'SSupp';
flowdata.State.c_configs = {'KLockSt','KLockSw'};
flowdata.State.Eref = 0;
flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;
flowdata.resetFlags();

input('Press enter to see animation')
[fstate, xout, tout, out_extra] = walk(xopt,2);
animate(xout,tout,out_extra,1/2,'test')