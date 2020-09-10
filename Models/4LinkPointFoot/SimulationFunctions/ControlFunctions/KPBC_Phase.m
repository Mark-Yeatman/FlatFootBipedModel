function u = KPBC_Phase(x)
    %BALLKPBC Kinetic Passivity-Based Control
    global flowdata

    dim = flowdata.Parameters.dim;
    
    k = flowdata.Parameters.KPBC.k;
    omega = flowdata.Parameters.KPBC.omega;  
    
    qdot = x( dim/2+1 : dim );
    params = cell2mat(flowdata.Parameters.Biped.values);
    E = flowdata.E_func(x,params);
    [Eref,Eref_part] = Eref_func(x);
    
    B = flowdata.Parameters.KPBC.B;
    Bi = inv(B'*B)*B';
    u = B*( -k*(E - Eref)*B'*qdot + Bi*Eref_part);
    u = u(:);
end

