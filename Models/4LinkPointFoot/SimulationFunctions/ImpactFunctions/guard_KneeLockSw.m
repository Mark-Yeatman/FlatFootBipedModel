function [value, isterminal, direction] = guard_KneeLockSw(t, x)
%GUARD_KNEELOCKST Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;

    value = x(6);
    isterminal = x(6+dim/2)>1e-3;
    direction = 1;
end

