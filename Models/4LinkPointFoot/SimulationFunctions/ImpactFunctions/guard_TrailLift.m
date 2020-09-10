function [value, isterminal, direction] = guard_TrailLift(t,x)
%GUARD_TRAILLIFT Summary of this function goes here
%   Detailed explanation goes here
    [GRF,F] = getGroundReactionForces(t,x);
	value = GRF(4);
    isterminal = 1;
    direction = -1;
end

