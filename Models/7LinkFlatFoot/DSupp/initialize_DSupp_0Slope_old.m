global dim eqnhandle odeoptions %ode parameters
global phaseStruct
global M M1 M2 Mp Mf Mt Ms Mss Mts Mfs g L la l1 l2 I1x I1y I1z I2x I2y I2z Ipx Ipy Ipz slope lf %mechanics parameters
global kp kd setpos           %PD control parameters
global k omega satU Einject   %PBC parameters
global Efunc                  %Mechanical energy calc handle
global silent ignore
global R
global mu
path(pathdef)
addpath('DynamicsFunctions')
addpath('ControlFunctions')
addpath('ImpactFunctions')
addpath('EnergyFunctions')
addpath('4PhaseParameters')
%ode equation handle and tolerenaces
eqnhandle = @dynamics;
odeoptions = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%print output as simulation progresses
silent = false;
%ignore simulation validation checks
ignore = true;

%simulation parameters
g = 9.81;       %gravitation acceleration
slope = 0;  %ground slope
dim = 16;       %state variable dimension
R = [zeros(1,8);
     zeros(1,8);
     0,0,1,1,1,1,1,1;
     0,0,0,0,0,0,0,-1;
     0,0,0,0,0,0,-1,0;
     0,0,0,0,0,-1,0,0;
     0,0,0,0,-1,0,0,0;
     0,0,0,-1,0,0,0,0];
mu =inf;

%PBC parameters
satU = inf;
k = 0;
omega = diag([0,0,0,1,1,0.001,1,1]);
Einject = 0;

%Load more parameters
Efunc = @Energy_Total;
load('MassInertiaGeometry.mat')
load('PDControlParameters4Phase.mat')
load('PhaseStruct4Phase0x0.mat')
load('initialcond_4phaseS0x0.mat')


