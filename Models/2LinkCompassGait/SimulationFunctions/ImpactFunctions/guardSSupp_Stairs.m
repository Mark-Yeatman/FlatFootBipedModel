function [value, isterminal, direction] = guardSSupp_Stairs(t, x)
global flowdata  
    %Leading foot to ground angle
    clearance = swingFootClearance(x);
    if isfield(flowdata.Parameters.Environment,'StairHeight')
        sh = flowdata.Parameters.Environment.StairHeight;
    else
        sh = 0.037037176242425; %from goswami/spong compass gait limit cycle delta y
    end
    if flowdata.Flags.do_validation
        CV = constraintValidation(0,x);
    else
        CV=[]; 
    end
    a = flowdata.eqnhandle(t,x);
    %value, isterminal, direction
    deltay = Foot_Sw_pos_func(x)-Foot_St_pos_func(x);
    FootStrike  = [deltay(2,4) + sh, x(4)>0.1, -1];
    guard = FootStrike';
    %guard =[FootStrike',  COPatLead'];
    value=       guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);
end