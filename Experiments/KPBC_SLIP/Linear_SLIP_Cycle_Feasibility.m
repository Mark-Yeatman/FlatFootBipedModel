
global L_0 m xdot_0 yapex

L_0 = 1;
m = 80;
xdot_0 = 6;
yapex = 1.1*L_0;

%(     t_s, t_b, k,     E_l, phi,    x_0,  y_0, ydot_0, theta_0,          thetadot_0)
a_0 = [0.5, 0.5, 12000, 500, pi/16, -0.25, 1,   3,      deg2rad(90 + 40), deg2rad(400)];
init_cost = EQ_Constraints(a_0);
init_c = Constraints(a_0);
options = optimoptions('fmincon');
options.Display = 'iter-detailed';
%[xstar,fval,exitflag,output,lambda,grad,hessian] = fmincon(@EQ_Constraints,a_0,[],[],[],[],[],[],@Constraints,options);
[xstar,fval,exitflag,output,lambda,grad,hessian] = fmincon(@my_cost,a_0,[],[],[],[],[],[],@Con2,options);

t_s = xstar(1)
t_b = xstar(2)
k = xstar(3)
E_l = xstar(4)
phi = xstar(5)
x_0 = xstar(6)
y_0 = xstar(7) 
ydot_0 = xstar(8) 
theta_0 =xstar(9)
thetadot_0  = xstar(10)

t_stance = linspace(0,t_s,1000);
t_ballistic = linspace(0,t_b,1000);

x_stance = zeros(size(t_stance));
y_stance = zeros(size(t_stance));

x_ballistic = zeros(size(t_stance));
y_ballistic = zeros(size(t_stance));

for i = 1:length(t_stance)
   L_stance = L(t_stance(i),phi,E_l,k,m,L_0);
   Theta_stance = Theta(t_stance(i),theta_0,thetadot_0);
   Ldot_stance = Ldot(t_stance(i),phi,E_l,k,m);
   Thetadot_stance = thetadot_0;
   q_s = LThetatoXY([L_stance,Theta_stance,Ldot_stance,Thetadot_stance]);
   x_stance(i) = q_s(1);
   y_stance(i) = q_s(2);
end

for i = 1:length(t_ballistic)
   x_ballistic(i) = X(t_ballistic(i),x_0,xdot_0);
   y_ballistic(i) = Y(t_ballistic(i),y_0,ydot_0);
end

x_test = [x_stance,x_ballistic];
y_test = [y_stance,y_ballistic];

subplot(3,1,1)
plot(x_stance,y_stance, x_ballistic, y_ballistic)
title('x-y Trajectory')
xlabel('x (m)')
ylabel('y (m)')
legend('Stance' , 'Flight')

subplot(3,1,2)
plot(x_stance,y_stance)
title('x-y Stance Trajectory')
xlabel('x (m)')
ylabel('y (m)')

subplot(3,1,3)
plot(x_ballistic, y_ballistic)
title('x-y Flight Trajectory')
xlabel('x (m)')
ylabel('y (m)')

%%
function L_out = L(t,phi,E_l,k,m,L_0)
    A = sqrt(2*E_l/k);
    f = sqrt(k/m);
    L_out = A*cos(f*t+phi) + L_0;
end

function Ldot_out = Ldot(t,phi,E_l,k,m)
    A = sqrt(2*E_l/k);
    f = sqrt(k/m);
    Ldot_out =  -A*f*sin(f*t+phi);
end

function theta_out = Theta(t,theta_0,thetadot_0)
    theta_out = theta_0 + t*thetadot_0;
end

function x_out = X(t,x_0,xdot_0)
    x_out = x_0 + t*xdot_0;
end

function y_out = Y(t,y_0,ydot_0)
     y_out = -9.81/2*t^2 + ydot_0*t + y_0;
end

function ydot_out = Ydot(t,ydot_0)
    ydot_out = -9.81*t + ydot_0;
end

function z = XYtoLTheta(x)
    %XYTOLTHETA Summary of this function goes here
    %   Detailed explanation goes here
    dim = 4;
    x0 = 0;
    y0 = 0;
    x = x';
        q = x(1:dim/2);         %position
        qdot = x(dim/2+1:dim);  %velocity

        L = sqrt((q(1)-x0)^2 + (q(2)-y0)^2);
        theta = atan2(q(2)-y0,q(1)-x0);

        T = [cos(theta), -sin(theta)*L;...
             sin(theta),  cos(theta)*L];
        phi_dot = T \ qdot;
        z = [L;theta;phi_dot];

end

function q = LThetatoXY(z)
    %LTHETATOXY Summary of this function goes here
    %   Detailed explanation goes here
    L = z(1);
    theta = z(2);
    dL = z(3);
    dtheta = z(4);
    y = L*sin(theta);
    x = L*cos(theta);
    dy = dL*sin(theta) + L*dtheta*cos(theta);
    dx = dL*cos(theta) - L*dtheta*sin(theta);
    q = [x,y,dx,dy]';
end
%%
function j = my_cost(v)
    global L_0 m xdot_0 yapex
    t_s = v(1);
    t_b = v(2);
    k = v(3); 
    E_l = v(4); 
    phi = v(5);
    x_0 = v(6); 
    y_0 = v(7); 
    ydot_0 = v(8); 
    theta_0 =v(9); 
    thetadot_0  = v(10);
    
    j = (yapex - (ydot_0^2/2/9.81+y_0))^2;
end

function [c,ceq] = Con2(v)
    global L_0 m xdot_0 yapex
    
    t_s = v(1);
    t_b = v(2);
    k = v(3); 
    E_l = v(4); 
    phi = v(5);
    x_0 = v(6); 
    y_0 = v(7); 
    ydot_0 = v(8); 
    theta_0 =v(9); 
    thetadot_0  = v(10);
    
    %Stance
    L_s = L(t_s,phi,E_l,k,m,L_0);
    Ldot_s = Ldot(t_s,phi,E_l,k,m);
    Theta_s = Theta(t_s,theta_0,thetadot_0);
    Thetadot_s = thetadot_0;
    
    X_s = X(0,x_0,xdot_0);
    Xdot_s = xdot_0;
    Y_s = Y(0,y_0,ydot_0);
    Ydot_s = Ydot(0,ydot_0);
    
    %Ballistic
    L_b = L(0,phi,E_l,k,m,L_0);
    Ldot_b = Ldot(0,phi,E_l,k,m);
    Theta_b = Theta(0,theta_0,thetadot_0);
    Thetadot_b = thetadot_0;
    
    X_b = X(t_b,x_0,xdot_0);
    Xdot_b = xdot_0;
    Y_b = Y(t_b,y_0,ydot_0);
    Ydot_b = Ydot(t_b,ydot_0);
    
    q_s = LThetatoXY([L_s,Theta_s,Ldot_s,Thetadot_s]);
    z_b = XYtoLTheta([X_b,Y_b,Xdot_b,Ydot_b]);
    
    ceq(1) = X_s - q_s(1);
    ceq(2) = Y_s - q_s(2);
    ceq(3) = Xdot_s - q_s(3);
    ceq(4) = Ydot_s - q_s(4);
    ceq(5) = L_b - z_b(1);
    ceq(6) = Theta_b - z_b(2);
    ceq(7) = Ldot_b - z_b(3);
    ceq(8) = Thetadot_b - z_b(4); 
    %ceq(9) = yapex - (ydot_0^2/2/9.81+y_0);
    ceq(9) = Y_s - Y_b;
    %c = sum(c.^2);
    
   c(1) = -t_s; 
   c(2) = -t_b;
   c(3) = -k;
   c(4) = -E_l;
   c(5) = -x_0-L_0;
   c(6) = L_0*sin(theta_0) - y_0;
   c(7) = -thetadot_0;
   c(8) = -ydot_0;
   c(9) = x_0;
   c(10) = 1/2/pi *sqrt(k/m) - t_b;
   c = c(:);
end
%%
function c = EQ_Constraints(v)
    %t_s is end of stance time
    %t_b is end of ballistic time
    global L_0 m xdot_0 yapex
    
    t_s = v(1);
    t_b = v(2);
    k = v(3); 
    E_l = v(4); 
    phi = v(5);
    x_0 = v(6); 
    y_0 = v(7); 
    ydot_0 = v(8); 
    theta_0 =v(9); 
    thetadot_0  = v(10);
    
    %Stance
    L_s = L(t_s,phi,E_l,k,m,L_0);
    Ldot_s = Ldot(t_s,phi,E_l,k,m);
    Theta_s = Theta(t_s,theta_0,thetadot_0);
    Thetadot_s = thetadot_0;
    
    X_s = X(0,x_0,xdot_0);
    Xdot_s = xdot_0;
    Y_s = Y(0,y_0,ydot_0);
    Ydot_s = Ydot(0,ydot_0);
    
    %Ballistic
    L_b = L(0,phi,E_l,k,m,L_0);
    Ldot_b = Ldot(0,phi,E_l,k,m);
    Theta_b = Theta(0,theta_0,thetadot_0);
    Thetadot_b = thetadot_0;
    
    X_b = X(t_b,x_0,xdot_0);
    Xdot_b = xdot_0;
    Y_b = Y(t_b,y_0,ydot_0);
    Ydot_b = Ydot(t_b,ydot_0);
    
    q_s = LThetatoXY([L_s,Theta_s,Ldot_s,Thetadot_s]);
    z_b = XYtoLTheta([X_b,Y_b,Xdot_b,Ydot_b]);
    
    c(1) = X_s - q_s(1);
    c(2) = Y_s - q_s(2);
    c(3) = Xdot_s - q_s(3);
    c(4) = Ydot_s - q_s(4);
    c(5) = L_b - z_b(1);
    c(6) = Theta_b - z_b(2);
    c(7) = Ldot_b - z_b(3);
    c(8) = Thetadot_b - z_b(4); 
    c(9) = yapex - (ydot_0^2/2/9.81+y_0);
    c(10) = Y_s - Y_b;
    c = sum(c.^2);
end

function [c,ceq] = Constraints(v)
    global L_0 m xdot_0
    
    t_s = v(1);
    t_b = v(2);
    k = v(3); 
    E_l = v(4); 
    phi = v(5);
    x_0 = v(6); 
    y_0 = v(7); 
    ydot_0 = v(8); 
    theta_0 = v(9); 
    thetadot_0  = v(10); 
    
   c(1) = -t_s; 
   c(2) = -t_b;
   c(3) = -k;
   c(4) = -E_l;
   c(5) = -x_0-L_0;
   c(6) = L_0*sin(theta_0) - y_0;
   c(7) = -thetadot_0;
   c(8) = -ydot_0;
   c(9) = x_0;
   c(10) = 1/2/pi *sqrt(k/m) - t_b;
   c = c(:);
   
   ceq = [] ;
end