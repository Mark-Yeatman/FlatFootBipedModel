function [value, isterminal, direction] = guard_LeadStrike(t, x)
%GUARD_LEADSTRIKE Summary of this function goes here
%   Detailed explanation goes here
    global flowdata

    value = x(2) - flowdata.Parameters.SLIP.L0*sin(flowdata.State.alpha);
    %only strike when mass in front of first 'foot'
    isterminal  = x(1) > flowdata.State.pf1(1);
    direction = -1;

end

