function [u,Farray,uArray] = ETrackS_func(x)
%ETrackS_func Energy tracking controller applied along the sping axis.
    %  
global flowdata

    k = flowdata.Parameters.KPBC.k;  
    sat = flowdata.Parameters.KPBC.sat;
    pf = flowdata.State.pf1;
    
    E = SpringAxisEnergy_func(x,pf);
    phase = flowdata.State.c_phase;

    if strcmp(phase,'SSupp')
        Eref = flowdata.State.Eref;
        pf = flowdata.State.pf1;       
        Ldot = Spring_Velocity_func(x,pf);
        J = Spring_Jacobian_func(x,pf);
        
        F = -k*(E - Eref)*Ldot;
        F(abs(F)>sat) = sign(F(abs(F)>sat)) * sat;        
        
        u = J*F;
        u = u(:); %makes sure its a column vector
        uArray = [u,nan(2,1)];
        Farray = [F,nan];
    elseif strcmp(phase,'DSupp')
        u = [0;0];
        Farray = [nan,nan]; 
        uArray = nan(2,2);
    else
        u = [0;0];
        Farray = [nan,nan]; 
        uArray = nan(2,2);
    end
    ee = 1;
    u(abs(u)<ee) = 0;

end