function [value, isterminal, direction] = guardToe(~, x)
%
% guardToe determines when to LEAVE the Toe constraint
%
global flowdata  
    slope = flowdata.Parameters.Environment.slope;
    dim = flowdata.Parameters.dim;
    
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim); 
           
    temp = swingHeelClearance(q,qdot);
    sw_heel_height = temp(1);
    
    foot_angle = slope - x(3);
    
    if flowdata.Flags.do_validation
        CV = constraintValidation(0,x);
    else
        CV=[]; 
    end
      
    dontcheck = [1, 0, 0];
    
    Footslap = dontcheck;%[foot_angle, 1, 0];
    Tiptoe = dontcheck;
    Heelstrike = [sw_heel_height, 1, 0];
    Toeoff = dontcheck;
    
    guard = [Footslap',  Tiptoe', Heelstrike', Toeoff', CV];
    value =      guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);   
end