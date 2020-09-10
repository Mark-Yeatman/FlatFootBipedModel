function [value, isterminal, direction] = guard_FootStrike(t,x)
%FOOTSTRIKE Summary of this function goes here
%   Detailed explanation goes here
    [clearance, vel_clearance] = swingFootClearance(x);
    hip_angle  = x(5);
    
    value  = clearance;  
    isterminal = vel_clearance<1e-6 && hip_angle>deg2rad(0.1);
    direction = -1;
end

