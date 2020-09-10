function [value, isterminal, direction] = guardFlat(~, x) 
global flowdata  
    lf = flowdata.Parameters.Biped.lf;
    dim = flowdata.Parameters.dim;
    
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);

    Lambda = feval(flowdata.eqnhandle, 0, x, 'L');
    cop_ff = Foot_CoP(Lambda);
    COP2Toe = lf+cop_ff;
        
    temp = swingHeelClearance(q,qdot);
    sw_heel_height = temp(1);

    if flowdata.Flags.do_validation
        CV = constraintValidation(0,x);
    else
        CV=[]; 
    end
    
    e = 0.001;  
    dontcheck = [1, 0, 0];
    
    Footslap = dontcheck;
    Tiptoe = [COP2Toe+e, 1, 0];
    Heelstrike = [sw_heel_height, 1, 0];
    Toeoff = dontcheck;
    
    guard = [Footslap',  Tiptoe', Heelstrike', Toeoff', CV];
    value =      guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);
end