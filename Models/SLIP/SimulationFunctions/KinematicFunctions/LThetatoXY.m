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

