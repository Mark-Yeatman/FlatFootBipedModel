function [z,zdot,A,Adot] = getHolonomicConstraint(x)
    %GETHOLONOMICCONSTRAINT Outputs the value of the constraint function, its
    %derivative, the Jacobian and its time derivative. 
    global flowdata
    params = cell2mat(flowdata.Parameters.Biped.values());
    z = VHC_func(x,params);
    A = A_VHC_func(x,params);
    qdot = x(flowdata.Parameters.dim/2+1:flowdata.Parameters.dim);
    zdot = A*qdot;
    Adot = Adot_VHC_func(x,params);
end

