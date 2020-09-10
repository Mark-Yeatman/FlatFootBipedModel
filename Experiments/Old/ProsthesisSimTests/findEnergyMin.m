x0 = [0.0000   -0.0000   -0.0054   -0.8755    0.0000   -0.0000    0   0]';
Ms = 6.991429/2.205; % converted to kg
Mf = 0.55 + 1.643130/2.205; %carbon fiber foot + mechanism, kg
lt = 0.0959; %meters
ls = 0.3733; %meters
la = 0.0628; %meters
lf = 0.15; %meters
px = 0; %meters
py = 0; %meters
params = [Ms, Mf, lt, ls, la, lf, px, py];
clear xin
fun = @(xin)E_func(xin,params);

Aeq = [1,0,0,0,0,0,0,0;
     0,1,0,0,0,0,0,0;
     0,0,0,0,1,0,0,0;
     0,0,0,0,0,1,0,0;
     0,0,0,0,0,0,1,0;
     0,0,0,0,0,0,0,1];
beq = zeros(6,1);
[x_opt,E_opt] = fmincon(fun,x0,[],[],Aeq,beq)