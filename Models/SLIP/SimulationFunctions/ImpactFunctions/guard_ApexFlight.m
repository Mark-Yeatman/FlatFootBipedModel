function [value, isterminal, direction] = guard_ApexFlight(t, x)
%GUARD_TRAILRELEASE Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    value = x(4);
    %check after 0.1 seconds to prevent zeno, and only during single support
    isterminal = strcmp('Flight',flowdata.State.c_phase); 
    direction = 0;
end

