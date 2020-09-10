function u = KPBC(x)
global flowdata
    k = flowdata.Parameters.KPBC.k;
    omega = flowdata.Parameters.KPBC.omega;
    satU = flowdata.Parameters.KPBC.sat;
    
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity
    
    W = x(dim+1);
    GenE = flowdata.E_func(x) - W;
    Eref = flowdata.Parameters.KPBC.Eref;
   
    %Regular Coordinates
%     u = -k*omega*(GenE - Eref)*qdot;
%     u(abs(u)>satU) = sign(u(abs(u)>satU)) * satU; 
    %SLIP Coordinates
    Ldot = Spring_vel_Heel_func(x);
    J = Spring_Jacobian_Heel_func(x);
    u  = -J(1:5)*k*(GenE - Eref)*Ldot;
    u(abs(u)>satU) = sign(u(abs(u)>satU)) * satU; 
    
    %uout = zeros(size(qdot));
    
    %Biomemetic torque saturation
%     if u(3)*qdot(3) < 0
%         u(3) = 0;
%     end
%     if u(4)*qdot(4) > 0
%         u(4) = 0;
%     end
    u = u(:); %get column vector
end