function [value, isterminal, direction] = guardDSupp(~, x)
global flowdata
    slope = flowdata.Parameters.Environment.slope;
    %Remember the trailing foot still has the x,y coordinates until after double support
    Lambda = feval(flowdata.eqnhandle, 0, x, 'L');
    Fx = Lambda(1);
    Fy = Lambda(2);
    [~,Fn] = ForceTanNorm(slope,Fx,Fy);
       
    if flowdata.Flags.do_validation
        CV = constraintValidation(0,x);
    else
        CV=[]; 
    end
    
    dontcheck = [1, 0, 0];
    
    Footslap = dontcheck;
    Tiptoe = dontcheck;
    Heelstrike = dontcheck;
    Toeoff = [Fn,1,1];
    
    guard = [Footslap',  Tiptoe', Heelstrike', Toeoff', CV];
    value =      guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);   
    
end