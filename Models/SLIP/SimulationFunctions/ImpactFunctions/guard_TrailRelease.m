function [value, isterminal, direction] = guard_TrailRelease(t, x)
%GUARD_TRAILRELEASE Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    L = Spring_Length_func(x,flowdata.State.pf2);
	value = L-flowdata.Parameters.SLIP.L0;
    isterminal = x(4)>0;
    direction = 1;
end

