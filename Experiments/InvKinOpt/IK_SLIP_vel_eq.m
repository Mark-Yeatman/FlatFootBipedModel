function e_vel = IK_SLIP_vel_eq(x,SLIP_xy)
    %IK_COST Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    x= x(:);
    
    com_p_vel= Hip_vel_func(x,params);
    com_vel = com_p_vel(1:2,4);
    e_com_vel = SLIP_xy(3:4)'-com_vel;
    e_com_vel = e_com_vel(:);
    
    toe_p_vel= Toe_Sw_vel_func(x,params);
    toe_vel = toe_p_vel(1:2,4);
    e_toe_vel = toe_vel(:);
    
    e_vel = [e_com_vel;e_toe_vel];

end

