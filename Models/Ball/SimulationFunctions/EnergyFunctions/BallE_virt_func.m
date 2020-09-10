function E = BallE_virt_func(x)
    %BALLE_VIRT_FUNC Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    m = flowdata.Parameters.VirtE.m;
    k = flowdata.Parameters.VirtE.k;
    L0 = flowdata.Parameters.VirtE.L0;
    dy = x(4);
    y = x(2);
    E = 1/2*m*dy^2 + 1/2*k*(y-L0)^2;
end

