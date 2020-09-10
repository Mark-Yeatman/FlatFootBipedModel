function u = PD(x)
    global flowdata
    dim = flowdata.Parameters.dim;
    kd = flowdata.Parameters.PD.KD;
    kp = flowdata.Parameters.PD.KP;
    xstar = flowdata.Parameters.PD.setpoint;
    u = zeros(1,dim/2);
    u(4:5) = -kp.*(x(4:5)-xstar) -kd.*(x(9:10));
    u = u(:);
end