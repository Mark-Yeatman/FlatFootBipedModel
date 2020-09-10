function [value, isterminal, direction] = guard_Impact(t, x)
    %GUARD_IMPACT Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    value = x(2);
    isterminal = x(4)<0;
    direction = 0;
end

