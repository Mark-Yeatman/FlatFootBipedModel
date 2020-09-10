function u = KPBC(x)
global flowdata
    k = flowdata.Parameters.KPBC.k;
    omega = flowdata.Parameters.KPBC.omega;
    satU = flowdata.Parameters.KPBC.sat;
    dim = flowdata.Parameters.dim;
    if isfield(flowdata.Parameters,'Shaping')
        params = cell2mat(flowdata.Parameters.Shaping.values);
    else
        params = cell2mat(flowdata.Parameters.Biped.values);
    end
    
    E = flowdata.E_func(x,params);
    if isfield(flowdata.Parameters,'Eref_Update')
        Eref = flowdata.State.Eref;   
    else
        Eref = flowdata.Parameters.KPBC.Eref;   
    end
    
    qdot = x( dim/2+1 : dim );
    if isfield(flowdata.Parameters,'Shaping')
        biped_params = cell2mat(flowdata.Parameters.Biped.values);
        shaping_params = cell2mat(flowdata.Parameters.Shaping.values);
        M = M_func(x,biped_params);
        Md = M_func(x,shaping_params);
        
        u = -k*omega*(E - Eref)*qdot;
        Mnew = zeros(4,4);
        Mnew(3:4,3:4) = M(3:4,3:4)/Md(3:4,3:4);
        u = -k*inv(M)*Md*(E - Eref)*qdot;
        %u = -Mnew*k*omega*(E - Eref)*qdot;
    else
        u = -k*omega*(E - Eref)*qdot;
    end
    
    u(1:2) = 0;
    u(abs(u)>satU) = sign(u(abs(u)>satU)) * satU; 
    
    if any(isnan(u))
       warning("KPBC Control returned NaN")
    end
    
end