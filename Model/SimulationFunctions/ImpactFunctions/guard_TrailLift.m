function [value, isterminal, direction] = guard_TrailLift(t, x)
global flowdata
    slope = flowdata.Parameters.Environment.slope;
    
    %Remember to check the constraint matrix Afunc to make sure you're getting the right vector
    %The trailing constraint should be first in all cases so this works
    %consistently.
    lambda = Lambda(t,x');
    Fx = lambda(1);
    Fy = lambda(2);
    [~,Fn] = ForceTanNorm(slope,Fx,Fy);
               
    value = Fn;
    isterminal = 1;
    direction =  0; 
    
end