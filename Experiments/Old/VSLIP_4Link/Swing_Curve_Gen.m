%Run the simulation over double support. Find the starting and ending
%points. Generate a curve that connects them in swing phase.
clear all
path(pathdef)
addpath('Experiments\SLIP_in_4Link\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\4LinkPointFoot\SLIPConfigNOTWORKING'))

initialize4Link_SLIP_LimitCycle
flowdata.End_Step.event_name = 'TrailLift'; 
flowdata.State.L0_a = flowdata.Parameters.SLIP.L0;
flowdata.State.L0_b = flowdata.Parameters.SLIP.L0;

[fstate, xout, tout, out_extra] = walk(xa,1);

n = flowdata.Parameters.dim/2;
R = [ zeros(1,n);
      zeros(1,n);
      0,0,ones(1,n-2);[zeros(n-3,3),flip(-1*eye(n-3),1)]];
R_sup = [R,zeros(n);zeros(n),R];

xe = xout(end,:);
xs = (R_sup*xa')';
xf = fstate;

M = M_func(xs');
A = A_Swap_func(xs');
C = A_SSupp_func(xs');
a = rank(A);
c = rank(C);

B = [M;A];
I = [M,A';C,zeros(c,a)];

qdot_next = xs(n+1:end)';
temp = I\B*qdot_next;
q_e = xs(1:n)';
qdot_e = temp(1:n);

nC = null(C);
P = nC*(nC'*nC)^-1*nC';

xtest = [q_e;P*qdot_e]';
xtest(1:2) = xtest(1:2); 

h1 = Foot_Sw_pos_func(xe');
h1dot = Foot_Sw_vel_func(xe');

h2 = Foot_Sw_pos_func(xtest');
h2dot = Foot_Sw_vel_func(xtest');

p1 = [h1(1:2,4)';h1dot(1:2,4)'];
p2 = [h2(1:2,4)';h2dot(1:2,4)'];

B = BezierSpline(3);
B.MatchEndPoints(p1,p2,1)
[x,y] = B(linspace(0,1,100));
draw4Link(xa','na');
plot(p1(1),p1(2),'b*');
plot(p2(1),p2(2),'r*');
plot(x,y, 'blue');