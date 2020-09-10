function [theta,t,x,y,fstar] = ContactAnglefromContactVelocity(dq_d,t_0,q_0,L_0)
    global flowdata
    f = @(t) (dq_d - BallisticThetaDot(t,q_0,L_0))^2;
    
    A = [];
    b = [];
    Aeq = [];
    beq= [];
    lb = 0;
    ub = 0.25;
    nonlcon = [];
    options = optimoptions('fmincon',"OptimalityTolerance",1e-12,"StepTolerance",1e-12);
    t = fmincon(f,t_0,A,b,Aeq,beq,lb,ub,nonlcon,options);
    
    %t = fminsearch(f,t_0);
    
    g = 9.81;
    x_0 = q_0(1);
    y_0 = q_0(2);
    dx_0 = q_0(3);
    dy_0 = q_0(4);
    
    x = dx_0*t + x_0;
    y = -g*t^2/2 + dy_0*t + y_0;
    
    theta = asin(y/L_0);
    fstar = f(t);
    if fstar>1
       theta =  flowdata.State.alpha;
    end
end

