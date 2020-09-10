function [u,u_pbc] = Torque_func(x)
    %TORQUE_FUNC Control torque for the 7Link Biped
    %   Detailed explanation goes here
global flowdata
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);
    
    u_pd = PDControl4Phase(q,qdot);
    
    % Centralized 
%     W = x(dim+1);
%     E = flowdata.E_func(x);
%     GenE = E - W;
%     u_pbc = PBC(q,qdot, GenE, flowdata.State.Eref);
    
    % Decentralized
    W = x(dim+1);
    GenE = flowdata.State.Einit - W;
    u_pbc = PBC(q,qdot, GenE, flowdata.State.Eref);

    u = u_pd + u_pbc;
end

