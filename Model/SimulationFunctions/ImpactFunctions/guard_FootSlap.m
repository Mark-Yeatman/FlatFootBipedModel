function [value, isterminal, direction] = guard_FootSlap(~, x) 
global flowdata  
    
    value      = (x(3) - flowdata.Parameters.Environment.slope)<0;
    isterminal = 1;
    direction  =  0;
end