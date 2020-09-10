function E = Spring_E_func(x,params)
    %SPRING_E_FUNC Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    %params = flowdata.Parameters.Dynamics.asvector;
    L0 = flowdata.Parameters.SLIP.L0;
    k = flowdata.Parameters.SLIP.k;
    L = Spring_Length_func(x,params);
    E = 1/2*k*(L-L0).^2;
end

