function [u,Farray,uArray] = Forced_SpringF_func(x)
    %SPRING Computes spring force in the SLIP model
    %   Takes state vector as input and checks the phase in flowdata.State.c_phase
    global flowdata
    
    k = flowdata.Parameters.SLIP.k;
    L0 = flowdata.Parameters.SLIP.L0;
    if strcmp(flowdata.State.c_phase,"SSupp")
        pf = flowdata.State.pf1;
        L = Spring_Length_func(x,pf);
        F = -k*(L-L0);
        if isfield(flowdata.Parameters.SLIP,'d')
            d = flowdata.Parameters.SLIP.d;
            Ldot = Spring_Velocity_func(x,pf);
            F = F - d*Ldot;
        end
        u(1) = F*( x(1) - flowdata.State.pf1(1))/L;
        u(2) = F*( x(2) - flowdata.State.pf1(2))/L;
        u = u(:); %makes sure its a column vector
        
        Farray = [F,nan];
        uArray = [u,nan(2,1)];
        
    elseif strcmp(flowdata.State.c_phase,"DSupp")
        %pf1 is leading foot during double support
        pf1 = flowdata.State.pf1;
        L1 = Spring_Length_func(x,pf1);
        F1 = -k*(L1-L0);
        if isfield(flowdata.Parameters.SLIP,'d')
            d = flowdata.Parameters.SLIP.d;
            Ldot1 = Spring_Velocity_func(x,pf1);
            F1 = F1 - d*Ldot1;
        end
        u1(1) = F1*( x(1) - flowdata.State.pf1(1))/L1;
        u1(2) = F1*( x(2) - flowdata.State.pf1(2))/L1;
        u1 = u1(:); %makes sure its a column vector
        
        pf2 = flowdata.State.pf2;
        L2 = Spring_Length_func(x,pf2);
        F2 = -k*(L2-L0);
        if isfield(flowdata.Parameters.SLIP,'d')
            d = flowdata.Parameters.SLIP.d;
            Ldot2 = Spring_Velocity_func(x,pf2);
            F2 = F2 - d*Ldot2;
        end
        u2(1) = F2*( x(1) - flowdata.State.pf2(1))/L2;
        u2(2) = F2*( x(2) - flowdata.State.pf2(2))/L2;
        u2 = u2(:); %makes sure its a column vector
        
        u = u1+u2;
        Farray = [F1,F2];
        uArray = [u1,u2];
    else
        u = [0;0];
        Farray = [nan,nan];
        uArray = nan(2,2);
    end
    
end

