function xout = map_Landing(xprev,xnext)
%MAP_LANDING Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    L0 = flowdata.Parameters.SLIP.L0;
    alpha = flowdata.State.alpha;
    
    flowdata.State.pf2 = nan(2,1);
    flowdata.State.pf1 = [xnext(1) + L0*cos(alpha);0]; %keep y height at 0 because ground
    
    z = XYtoLTheta(xprev',flowdata.State.pf1);   
    %flowdata.Parameters.Shaping.k = flowdata.Parameters.Shaping.k*(z(4)*flowdata.State.z_prev(2)/flowdata.State.z_prev(4)/z(2))^2;
    
    flowdata.State.z_prev = z;
    
    %flowdata.Parameters.State.Eref = flowdata.State.A0^2*flowdata.Parameters.Shaping.k/2;
    
    xout = xnext;   
end

