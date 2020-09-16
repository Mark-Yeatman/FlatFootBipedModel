function cost = IK_SLIP_vel_cost(x,SLIP_xy,pf2)
    %IK_COST Summary of this function goes here
    %   Detailed explanation goes here
    x= x(:);
    
    com_p_vel= COM_vel_func(x);
    com_vel = com_p_vel(1:2);
    e_com_vel = SLIP_xy(3:4)-com_vel;
    e_com_vel = e_com_vel(:);
    
    toe_p_vel= Toe_Sw_vel_func(x);
    toe_vel = toe_p_vel(1:2,4);
    e_toe_vel = toe_vel(:);
    
    e_vel = [e_com_vel;e_toe_vel];
    
    cost = norm(e_vel,2);
end

