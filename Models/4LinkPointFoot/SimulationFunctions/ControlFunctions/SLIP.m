function [u,Farray,uArray] = SLIP(x)
    %SPRING Computes spring force in the SLIP model
    %   Takes state vector as input and checks the phase in flowdata.State.c_phase
    global flowdata
        
    %Gravity compensation
%     Gcomp = G_func(x,params)*0; %No gravity compensation          
%     Gcomp(1:2) = 0;
    Gcomp = zeros(flowdata.Parameters.dim/2,1);

    params = cell2mat(flowdata.Parameters.SLIP.values());
    k = flowdata.Parameters.SLIP('k');
    L0_a = flowdata.Parameters.SLIP('L0'); %flowdata.State.L0_a;
    L0_b = flowdata.Parameters.SLIP('L0');
    c = flowdata.Parameters.SLIP_e.c;
    a = flowdata.Parameters.SLIP_e.a;
    if strcmp(flowdata.State.c_phase,"SSupp") 
%         L = Spring_Length_1_func(x,params);
%         F = -k*(L-L0_a);

%         J = Spring_Jacobian_1_func(x,params);
%         u = J*F;
%         u = u(:); %makes sure its a column vector
%         
%         Farray = [F,nan];
%         uArray = [u,nan(6,1)];     
%         u = u + Gcomp;

    %pf1 is leading foot during double support
        %Spring
        L1 = Spring_Length_1_func(x,params);
        F1 = -k*(L1-L0_a);
        
        %Map Force
        J1 = Spring_Jacobian_1_func(x,params);
        u1 = J1*F1;
        u1 = u1(:); %makes sure its a column vector
        
    %pf2 is trailing foot during double support    
        L2 = Spring_Length_2_func(x,params);
        F2 = -k*c*(L2-L0_b*a);

        J2 = Spring_Jacobian_2_func(x,params);
        u2 = J2*F2;
        u2 = u2(:); %makes sure its a column vector
        
        u = u1 + u2 + Gcomp;
        Farray = [F1,F2];
        uArray = [u1,u2];

    elseif strcmp(flowdata.State.c_phase,"DSupp") 
        
    %pf1 is leading foot during double support
        %Spring
        L1 = Spring_Length_1_func(x,params);
        F1 = -k*(L1-L0_a);
        
        %Map Force
        J1 = Spring_Jacobian_1_func(x,params);
        u1 = J1*F1;
        u1 = u1(:); %makes sure its a column vector
        
    %pf2 is trailing foot during double support    
        L2 = Spring_Length_2_func(x,params);
        F2 = -k*(L2-L0_b);
        
        J2 = Spring_Jacobian_2_func(x,params);
        u2 = J2*F2;
        u2 = u2(:); %makes sure its a column vector
        
        u = u1 + u2 + Gcomp;
        Farray = [F1,F2];
        uArray = [u1,u2];
    else
        u = zeros(6,1);
        Farray = [nan,nan];
        uArray = zeros(6,2);
    end
    
end

