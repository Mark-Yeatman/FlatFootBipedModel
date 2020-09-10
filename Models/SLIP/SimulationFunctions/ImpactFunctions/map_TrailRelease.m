function xout = map_TrailRelease(xprev,xnext)
%MAP_LANDING Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    flowdata.State.pf2 = nan(2,1); %remove unconnected spring
    xout = xnext;   
end

