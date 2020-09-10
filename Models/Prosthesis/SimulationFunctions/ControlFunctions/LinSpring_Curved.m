function u = LinSpring_Curved(x)
%LinSpring Summary of this function goes here
%   Detailed eqplanation goes here
    global flowdata
    L0 = flowdata.Parameters.SLIP.L0;
    k = flowdata.Parameters.SLIP.k;
    
    L = Spring_Length_Curved_func(x);
    J = Spring_Jacobian_Curved_func(x);
    
    u = -J*k*(L - L0);   
    u = u(1:5);
end
