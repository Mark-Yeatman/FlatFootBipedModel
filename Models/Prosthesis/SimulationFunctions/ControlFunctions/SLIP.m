function u = SLIP(x)
%DSLIP Summary of this function goes here
%   Detailed eqplanation goes here
    global flowdata
    L0 = flowdata.Parameters.SLIP.L0;
    k = flowdata.Parameters.SLIP.k;
    d = flowdata.Parameters.SLIP.d;
    
%     L = Spring_Length_Curved_func(x);
%     J = Spring_Jacobian_Curved_func(x);
%     Ldot = Spring_vel_Curved_func(x);
    
    L = Spring_Length_Heel_func(x);
    J = Spring_Jacobian_Heel_func(x);
    Ldot = Spring_vel_Heel_func(x);
    
    u = -J*k*(L - L0) - J*d*Ldot;   
    u = u(1:5);
end
