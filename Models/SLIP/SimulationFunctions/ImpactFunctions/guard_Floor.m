function [value, isterminal, direction] = guard_Floor(t, x)
%GUARD_TRAILRELEASE Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    value = x(2);
    %check after 0.1 seconds to prevent zeno, and only during single support
    isterminal =  1; 
    direction = -1;
end

