function [u,Farray,uArray] = SLIP_Test(x)
    %SPRING Computes spring force in the SLIP model
    %   Takes state vector as input and checks the phase in flowdata.State.c_phase
    global flowdata

    params = cell2mat(flowdata.Parameters.SLIP.values());
    k = flowdata.Parameters.SLIP('k');
    L0_a = flowdata.Parameters.SLIP('L0'); %flowdata.State.L0_a;
    L0_b = flowdata.Parameters.SLIP('L0');

        
    %pf1 is leading foot during double support
    %Spring
    L1 = Spring_Length_1_func(x,params);
    F1 = -0*(L1-L0_a);

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

    u = u2;
    Farray = [F1,F2];
    uArray = [u1,u2];

    
end

