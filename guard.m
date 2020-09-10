function [value, isterminal, direction] = guard(t,x)
    %GUARD ODE integration termination conditions, like impacts.
    %   Loops through Impacts, 
    %   value, isterminal, direction must all be 1xN matrices
    global flowdata
    L = length(flowdata.Impacts);
    value = zeros(1,L);
    isterminal = zeros(1,L);
    direction = zeros(1,L);   
    for j = 1:L
        [v, i, d] = flowdata.Impacts{j}.f(t,x);
        value(j) = v;
        isterminal(j) =  i;
        direction(j) =  d;
    end
end

