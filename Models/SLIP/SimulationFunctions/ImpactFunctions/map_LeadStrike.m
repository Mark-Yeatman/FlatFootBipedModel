function xout = map_LeadStrike(xprev,xnext)
%MAP_LANDING Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    L0 = flowdata.Parameters.SLIP.L0;
    alpha = flowdata.State.alpha;
    flowdata.State.pf2 = flowdata.State.pf1; 
    flowdata.State.pf1(1) = xnext(1) + L0*cos(alpha); %keep y height at 0 because ground
    xout = xnext;   
end

