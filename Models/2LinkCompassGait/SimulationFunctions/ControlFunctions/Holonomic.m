function u = Holonomic(x)
    %HOLONOMIC A holonomic controller that drives the swing leg trajectory of a
    %4 link robot
    %   
    global flowdata
    params = flowdata.Parameters.Biped.asvector;
    dim = flowdata.Parameters.dim;
    
    u = zeros(dim/2,1);  
    if strcmp(flowdata.State.c_phase,"SSupp")
        q = x(1:dim/2);
        qdot = x(dim/2+1:dim);

        [z,zdot,A,Adot] = getHolonomicConstraint(x);
        [Ac,Acdot] = flowdata.getConstraintMtxs(x,params);
        Kp = flowdata.Parameters.Holonomic.Kp;
        Kd = flowdata.Parameters.Holonomic.Kd;
        B = flowdata.Parameters.Holonomic.B;
       
        M = M_func(x,params);
        A = [A;Ac];
        Adot = [Adot;Acdot];
        Bh = A*(M\B);
        C = C_func(x,params);
        G = G_func(x,params);
        %v = -Adot*qdot - (A/M)*(-C*qdot-G) -Kd*zdot - Kp*z;
        v = ((A/M)*A')\((A/M)*(- C*qdot - G) + Adot*qdot);
        
        %W = eye(rank(B));

        u = B*(B\(A'))*(-Kp*z -Kd*zdot - v);
    end
end