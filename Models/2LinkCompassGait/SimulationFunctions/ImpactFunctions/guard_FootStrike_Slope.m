function [value, isterminal, direction] = guard_FootStrike_Slope(t, x)  
    %Leading foot to ground angle
    clearance = swingFootClearance(x);

    %value, isterminal, direction
    FootStrike  = [clearance, x(4)>0.1, -1];
    guard =FootStrike';
    %guard =[FootStrike',  COPatLead'];
    value=       guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);
end