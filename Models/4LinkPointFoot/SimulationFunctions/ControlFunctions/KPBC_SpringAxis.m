function [u,Farray,uArray] = KPBC_SpringAxis(x)
%KPBC_SpringAxis Energy tracking controller for the SLIP model actuated
%along the sping axis.
    %   1 dimensional, so no weighting matrix
    
    global flowdata
    params = cell2mat(flowdata.Parameters.SLIP.values());
    k = flowdata.Parameters.KPBC.k; 
    sat = flowdata.Parameters.KPBC.sat;
    L0_a = flowdata.Parameters.SLIP('L0'); %flowdata.State.L0_a;
    L0_b = flowdata.Parameters.SLIP('L0');
    Eref = flowdata.Parameters.KPBC.Eref;
    
    if strcmp(flowdata.State.c_phase,"SSupp") 
        L = Spring_Length_1_func(x,params);
        Ldot = Spring_Velocity_1_func(x,params);
        
        E = 1/2*flowdata.Parameters.SLIP('k')*(L-flowdata.Parameters.SLIP('L0')).^2 ...
            + 1/2*flowdata.Parameters.Biped('Mh')*(x(3)^2+x(4)^2) ...
            + flowdata.Parameters.Biped('Mh')*x(2)*flowdata.Parameters.Environment.g;
        
        F = -k*(E - Eref)*Ldot;
        F(abs(F)>sat) = sign(F(abs(F)>sat)) * sat;     
         
        J = Spring_Jacobian_1_func(x,params);
        u = J*F;
        u = u(:); %makes sure its a column vector
        
        Farray = [F,nan];
        uArray = [u,nan(6,1)];     
        u = u;
        
    elseif strcmp(flowdata.State.c_phase,"DSupp") 
        
    %pf1 is leading foot during double support
        L1 = Spring_Length_1_func(x,params);
        Ldot1 = Spring_Velocity_1_func(x,params);
        
        E1 = 1/2*flowdata.Parameters.SLIP('k')*(L1-flowdata.Parameters.SLIP('L0')).^2 ...
             + 1/2*flowdata.Parameters.Biped('Mh')*(x(3)^2+x(4)^2) ...
             + flowdata.Parameters.Biped('Mh')*x(2)*flowdata.Parameters.Environment.g;
        
        F1 = -k*(E1 - Eref)*Ldot1;
        F1(abs(F1)>sat) = sign(F1(abs(F1)>sat)) * sat;     
         
        J1= Spring_Jacobian_1_func(x,params);
        u1 = J1*F1;
        u1 = u1(:); %makes sure its a column vector
                 
    %pf2 is trailing foot during double support    
        L2 = Spring_Length_2_func(x,params);
        Ldot2 = Spring_Velocity_2_func(x,params);
        
        E2 = 1/2*flowdata.Parameters.SLIP('k')*(L2-flowdata.Parameters.SLIP('L0')).^2 ...
             + 1/2*flowdata.Parameters.Biped('Mh')*(x(3)^2+x(4)^2)...
             + flowdata.Parameters.Biped('Mh')*x(2)*flowdata.Parameters.Environment.g;
        
        F2 = -k*(E2 - Eref)*Ldot2;
        F2(abs(F2)>sat) = sign(F2(abs(F2)>sat)) * sat;     
         
        J2= Spring_Jacobian_2_func(x,params);
        u2 = J2*F2;
        u2 = u2(:); %makes sure its a column vector
               
        u = u1 + u2;
        Farray = [F1,F2];
        uArray = [u1,u2];
    else
        u = zeros(6,1);
        Farray = [nan,nan];
        uArray = zeros(6,2);
    end
    
end

