function [value, isterminal, direction] = guard_HeelStrike(~, x)
%
% guardHeel determines when to switch from heel contact to flat contact.
%
global flowdata
    
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim); 
           
    temp = swingHeelClearance(q,qdot);
    sw_heel_height = temp(1);
    
    value = sw_heel_height;
    isterminal = 1;
    direction = 0;
end