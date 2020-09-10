clear all
path(pathdef)
addpath('Experiments\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

initializeCompassGaitLimitCycle

flowdata.Flags.do_validation = false;
[fstate, xout, tout, out_extra] = walk(xi,1);

n = flowdata.Parameters.dim/2;
R = [ zeros(1,n);
      zeros(1,n);
      0,0,ones(1,n-2);[zeros(n-3,3),flip(-1*eye(n-3),1)]];
R_sup = [R,zeros(n);zeros(n),R];

xe = xout(end,:);
xs = (R_sup*xi')';
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
F_e = temp(n+1:end);
nC = null(C);
P = nC*(nC'*nC)^-1*nC';
xtest = [q_e;P*qdot_e]';

xprev = xtest;
dim = flowdata.Parameters.dim;
qprev = xprev(1:dim/2)';
qdotprev = xprev(dim/2+1:dim)';
qnextmapped =  R*qprev;  
M = M_func(xprev');
temp = [M,-A';A,zeros(a)]\[M*qdotprev;zeros(a,1)]; 
qdotnext = temp(1:dim/2);
F = temp(dim/2+1:end);
qdotnextmapped = R*qdotnext;
xnext = [qnextmapped;qdotnextmapped];
xnext = reshape(xnext,size(xprev));