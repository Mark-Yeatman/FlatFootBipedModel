function u = Force_Control(t,x)
    %FORCECONTROL Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;
    params = flowdata.Parameters.Biped.asvec;
    k = flowdata.Parameters.Cntr.k;
    d = flowdata.Parameters.Cntr.d;
    L0 = flowdata.Parameters.Cntr.L0;
    
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity
    
    [A,Adot] = flowdata.getConstraintMtxs(q,qdot);
    M = M_func(x,params);
    C = C_func(x,params);
    G = G_func(x,params); 
    
    com_pos = COM_pos_func(x,params)';
    com_vel = COM_vel_func(x,params)';
    
    lf = flowdata.Parameters.Biped.lf;
    CoP_foot_frame = lf/2;

    v1 = com_pos(1:2)-(x(1:2)+[CoP_foot_frame;0]);
    %theta = atan2(v1(2),v1(1));
    %L = norm(v1,2);
    %V = com_vel(1);
    S = [-k*v1(1);-k*(v1(2)-L0)];
    g = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal];
    D = [-d*com_vel(1);0];
    F = (S+g+D)/flowdata.Parameters.Biped.MTotal;
      
   %Fx =-F(1);
    %Fy =-F(2); 
    la = flowdata.Parameters.Biped.lf;
    %lambda_d =  -(CoP_foot_frame*Fx+la*Fy);
    
    Jdot= COM_Jacobian_dot_func(x,params);
    Jdot = Jdot(1:2,:);
    J = COM_Jacobian_func(x,params);
    J = J(1:2,:);
    B = flowdata.Parameters.B;
    %Ao = A(1:2,:);
    %Ad = A(3,:);
    
    ud = -B*B'*null(J)*null(J)'*qdot*d;
    Theta = [zeros(1,rank(B)),-la,-CoP_foot_frame,1];
    W = [[A;J]*inv(M)*[B,A'];Theta];
    temp = pinv(W)*( [[Adot*qdot;F-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud);0]);
    u = B*temp(1:rank(B))+ud;
end

