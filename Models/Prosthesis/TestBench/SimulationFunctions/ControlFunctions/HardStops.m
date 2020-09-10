function u = HardStops(q)
    global flowdata
    dim = flowdata.Parameters.dim;
    kd = flowdata.Parameters.Hardstops.KD;
    kp = flowdata.Parameters.Hardstops.KP;
    up_lim = flowdata.Parameters.Hardstops.upper_limits;
    down_lim = flowdata.Parameters.Hardstops.lower_limits;
    u = zeros(1,dim/2);
    x = q([4:5,9:10]);
    if x(1) > up_lim(1)
        u(4) = -kp(1).*(x(1)-up_lim(1)) -kd(1).*x(3);
    end
    if x(1) < down_lim(1)
        u(4) = -kp(1).*(x(1)-down_lim(1)) -kd(1).*x(3);         
    end
    if x(2) > up_lim(2)
        u(5) = -kp(2).*(x(2)-up_lim(1)) -kd(2).*x(4);
    end
    if x(2) < down_lim(2)
        u(5) = -kp(2).*(x(2)-down_lim(2)) -kd(2).*x(4);         
    end
    u = u(:);
end