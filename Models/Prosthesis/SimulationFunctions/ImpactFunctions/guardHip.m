function [value, isterminal, direction] = guardHip(~, x)
%
% guardHeel determines when to switch from heel contact to flat contact.
%
global flowdata  
    slope = flowdata.Parameters.Environment.slope;
           
    foot_angle = slope - x(3);
       
    if flowdata.Flags.do_validation
        CV = constraintValidation(0,x);
    else
        CV=[]; 
    end
    
    dontcheck = [1, 0, 0];
    
    Footslap = dontcheck;
    Tiptoe = dontcheck;
    Heelstrike = dontcheck;
    Toeoff = dontcheck;
    
    guard = [Footslap',  Tiptoe', Heelstrike', Toeoff', CV];
    value =      guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);
    
end