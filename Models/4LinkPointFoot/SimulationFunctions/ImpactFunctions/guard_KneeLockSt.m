function [value, isterminal, direction] = guard_KneeLockSt(t, x)
%GUARD_KNEELOCKST Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;

    value = x(4);
    isterminal = x(4+dim/2)<-1e-3;
    direction = -1;
end

