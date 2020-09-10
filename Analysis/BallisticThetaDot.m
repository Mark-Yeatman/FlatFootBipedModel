function dtheta = BallisticThetaDot(t,q_0,L_0)
    %BALLISTICTHETADOT Summary of this function goes here
    %   Detailed explanation goes here
    g = 9.81;
    x_0 = q_0(1);
    y_0 = q_0(2);
    dx_0 = q_0(3);
    dy_0 = q_0(4);
    
    x = dx_0*t + x_0;
    y = -g*t^2/2 + dy_0*t + y_0;

    pf = zeros(2,1);
    if y>L_0
        dtheta = 10000;
    else
        theta = asin(y/L_0);
        pf(1) = x + L_0*cos(theta);
        pf(2) = 0;

        dx = dx_0;
        dy = dy_0 - g*t;

        z = XYtoLTheta([x,y,dx,dy]',pf);
        dtheta = z(4);
    end
end

