function u = KPBC(x)
global flowdata
    k = flowdata.Parameters.KPBC.k;
    omega = flowdata.Parameters.KPBC.omega;
    satU = flowdata.Parameters.KPBC.sat;
    
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity
    
    W = x(dim+1);
    params = flowdata.Parameters.Dynamics.asvector;
    GenE = W;%flowdata.E_func(x,params) - W;
    %GenE = flowdata.E_func(x,params);
    Eref = flowdata.Parameters.KPBC.Eref;
    %noise = 0*randn(size(qdot))*0.001;
    
    %% Regular Coordinates
    u = -k*omega*(GenE - Eref)*(qdot);
    u(abs(u)>satU) = sign(u(abs(u)>satU)) * satU; 

    %% SLIP Coordinates
    Ldot = Spring_vel_func(x,params);
    J = Spring_Jacobian_func(x,params);
    u  = -J*k*(GenE - Eref)*Ldot;
    u(abs(u)>satU) = sign(u(abs(u)>satU)) * satU; 
    
    %uout = zeros(size(qdot));
    
    %% Biomemetic torque saturation
%     if u(3)*qdot(3) < 0
%         u(3) = 0;
%     end
%     if u(4)*qdot(4) > 0
%         u(4) = 0;
%     end

%% 
    u = u(:); %get column vector
end