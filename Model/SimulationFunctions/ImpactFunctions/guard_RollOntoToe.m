function [value, isterminal, direction] = guard_Toe(~, x)
%
% guardToe determines when to LEAVE the Toe constraint
%
global flowdata  
    
    lf = flowdata.Parameters.Biped.lf;
    lambda = Lambda(0, x')';
    cop_ff = Foot_COP(lambda);
    COP2Toe = -lf+cop_ff;
     
    e = 0.001;  
    
    value      = COP2Toe+e;
    isterminal = 1;
    direction  =  0;
    
     
end