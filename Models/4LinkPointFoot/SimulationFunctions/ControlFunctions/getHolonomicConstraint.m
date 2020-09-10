function [z,zdot,A,Adot] = getHolonomicConstraint(x)
    %GETHOLONOMICCONSTRAINT Outputs the value of the constraint function, its
    %derivative, the Jacobian and its time derivative. 
    foot_sw_exp = Foot_Sw_pos_func(x);
    foot_st_exp = Foot_St_pos_func(x);
    foot_sw_exp_dot = Foot_Sw_vel_func(x);
    foot_st_exp_dot = Foot_St_vel_func(x);
    hip_exp = Hip_pos_func(x);
    hip_exp_dot = Hip_vel_func(x);
    a = hip_exp(1,4) -  foot_st_exp(1,4);
    b = foot_sw_exp(1,4) - hip_exp(1,4);
    adot = hip_exp_dot(1,4) -  foot_st_exp_dot(1,4);
    bdot = foot_sw_exp_dot(1,4) - hip_exp_dot(1,4);
    zdot = bdot-adot;
    z = b-a;
    A = A_VHC_func(x);
    Adot = Adot_VHC_func(x);
end

