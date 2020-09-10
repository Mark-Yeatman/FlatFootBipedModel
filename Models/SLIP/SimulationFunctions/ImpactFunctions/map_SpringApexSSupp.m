function xout = map_SpringApexSSupp(xprev,xnext)
%MAP_LANDING Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    L = Spring_Length_func(xprev,flowdata.State.pf1);
    flowdata.State.alpha = acos(xprev(2)/L) + deg2rad(65);
    xout = xnext;   
end

