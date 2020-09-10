function SE = SE_func(x)
    %SE_FUNC Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    SE = 1/2*flowdata.Parameters.Spring.k*(x(2) - flowdata.Parameters.Spring.L0)^2;
end

