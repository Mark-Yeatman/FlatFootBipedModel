function u = LinDamp_Curved(x)
%LinDampSummary of this function goes here
%   Detailed eqplanation goes here
    global flowdata
    d = flowdata.Parameters.SLIP.d;
    
    J = Spring_Jacobian_Curved_func(x);
    Ldot = Spring_vel_Curved_func(x);
    
    u = - J*d*Ldot;   
    u = u(1:5);
end
