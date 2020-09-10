function z = XYtoLTheta(x,pf)
    %XYTOLTHETA Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;
    x0 = pf(1);
    y0 = pf(2);
    if any(isnan(pf))
        z = nan(size(x));
    else
        q = x(1:dim/2);         %position
        qdot = x(dim/2+1:dim);  %velocity

        L = sqrt((q(1)-x0)^2 + (q(2)-y0)^2);
        theta = atan2(q(2)-y0,q(1)-x0);

        T = [cos(theta), -sin(theta)*L;...
             sin(theta),  cos(theta)*L];
        phi_dot = T \ qdot;
        z = [L;theta;phi_dot];
    end
end

