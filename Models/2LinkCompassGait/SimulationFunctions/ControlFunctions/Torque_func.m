function [u,u] = Torque_func(x)
    %TORQUE_FUNC Control torque for the CompassGait Config of the 4Link Biped
    %   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);
    E = flowdata.E_func(x);
    u = PBC(q,qdot, E, flowdata.State.Eref);
end

