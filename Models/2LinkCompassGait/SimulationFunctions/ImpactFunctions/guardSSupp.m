function [value, isterminal, direction] = guardSSupp(t, x)
global flowdata  
    %Leading foot to ground angle
    clearance = swingFootClearance(x);
    
    if flowdata.Flags.do_validation
        CV = constraintValidation(0,x);
    else
        CV=[]; 
    end
    a = flowdata.eqnhandle(t,x);
    %value, isterminal, direction
    FootStrike  = [clearance, x(4)>0.1, -1];
    guard =FootStrike';
    %guard =[FootStrike',  COPatLead'];
    value=       guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);
end