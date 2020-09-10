function [value, isterminal, direction] = guard_Landing(t, x)
%GUARD_LANDING Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    value = x(2)-flowdata.Parameters.SLIP.L0*sin(flowdata.State.alpha);
    isterminal =  x(4)<0;
    direction = -1;   
end

