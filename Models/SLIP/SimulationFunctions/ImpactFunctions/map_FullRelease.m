function xout = map_FullRelease(xprev,xnext)
%MAP_LANDING Summary of this function goes here
%   Detailed explanation goes here
     global flowdata
%     y_0 = xnext(2);
%     dy_0 = xnext(4);
%     L0 =flowdata.Parameters.SLIP.L0;
%     a = -9.81/2;
%     b = dy_0;
%     c = y_0-L0;
%     one = (-b - sqrt(b^2-4*a*c))/(2*a);
%     two = (-b + sqrt(b^2-4*a*c))/(2*a);
%     t_0 = max(one,two);
%     if ~isreal(t_0) || t_0<0
%        t_0 = 0;
%     end
%     
%     [theta,t,x,y,fstar] = ...
%         ContactAnglefromContactVelocity(flowdata.State.dtheta_ref,t_0,xnext,flowdata.Parameters.SLIP.L0);
%     if theta<deg2rad(45)
%         flowdata.State.alpha = deg2rad(45);
%     elseif theta>deg2rad(70)
%         flowdata.State.alpha = deg2rad(70);
%     else
%         flowdata.State.alpha = theta;
%     end
    
    flowdata.State.pf1= nan(2,1);
    flowdata.State.pf2 = nan(2,1);  
    xout = xnext;   
end

