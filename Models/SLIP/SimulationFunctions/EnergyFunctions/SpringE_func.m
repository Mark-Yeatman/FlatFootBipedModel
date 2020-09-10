function E = SpringE_func(x,pf)
%SPRINGE_FUNC Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    k = flowdata.Parameters.SLIP.k;
    L0 = flowdata.Parameters.SLIP.L0;
    L = Spring_Length_func(x,pf);
    E = 1/2*k*(L-L0)^2;
end

