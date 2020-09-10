function u = LinSpring_Flat(x)
%LinSpring Summary of this function goes here
%   Detailed eqplanation goes here
    global flowdata
    L0 = flowdata.Parameters.SLIP.L0;
    k = flowdata.Parameters.SLIP.k;
    

    L = Spring_Length_Heel_func(x);
    J = Spring_Jacobian_Heel_func(x);

    u = -J*k*(L - L0);   
    u = u(1:5);
end
