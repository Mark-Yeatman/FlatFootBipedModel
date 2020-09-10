function [u,Farray,uArray] = Spring_func(x)
    %SPRING Computes spring force in the SLIP model
    %   Takes state vector as input and checks the phase in flowdata.State.c_phase
    global flowdata
    
    k = flowdata.Parameters.SLIP.k;
    L0 = flowdata.Parameters.SLIP.L0;
    dim = flowdata.Parameters.dim;
 
    params = [L0,k];
    x = x(1:dim);
    W = x(dim+1:end);
    if strcmp(flowdata.State.c_phase,"SSupp")
        pf = flowdata.State.pf1(:);      
        F = Spring_Force_func(x,pf,params);
        J = Spring_Jacobian_func(x,pf);
        u = J*F; %makes sure its a column vector
        
        Farray = [F,nan];
        uArray = [u,nan(2,1)];
        
    elseif strcmp(flowdata.State.c_phase,"DSupp")
        %pf1 is leading foot during double support
        pf1 = flowdata.State.pf1(:);      
   
        F1 = Spring_Force_func(x,pf1,params);
        J1 = Spring_Jacobian_func(x,pf1);
        u1 = J1*F1; %makes sure its a column vector
        
        pf2 = flowdata.State.pf2(:);      
        F2 = Spring_Force_func(x,pf2,params);
        J2 = Spring_Jacobian_func(x,pf2);
        u2 = J2*F2; %makes sure its a column vector
        
        u = u1+u2;
        Farray = [F1,F2];
        uArray = [u1,u2];
    else
        u = [0;0];
        Farray = [nan,nan];
        uArray = nan(2,2);
    end
    
end

