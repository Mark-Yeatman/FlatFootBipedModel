function cost = IK_SLIP_pos_cost(x,SLIP_xy,pf2)
    %IK_COST Summary of this function goes here
    %   Detailed explanation goes here
    x= x(:);
    com_pose = COM_pos_func(x);
    com_xy = com_pose(1:2);
    
    SLIP_xy = SLIP_xy(:); %put into columns
    com_xy = com_xy(:);
    e_com_pos = SLIP_xy(1:2)-com_xy;
    e_com_pos = e_com_pos(:);

    toe_sw_pose = Toe_Sw_pos_func(x);
    toe_xy = toe_sw_pose(1:2,4);
    pf2 = pf2(:);
    e_toe_pos = toe_xy-pf2;
    e_toe_pos = e_toe_pos(:);
    
    e_pos = [e_com_pos;e_toe_pos];
        
    Js1 = Hip_Jacobian_func(x);
    Js1 = Js1(1:3,:);
    Js2 = Hip_Jacobian_func(x)-Toe_Sw_Jacobian_func(x);
    Js2 = Js2(1:3,:);
    
    sv1 = min(svd(Js1));
    sv2 = min(svd(Js2));
    cost = norm(e_pos,2) + 1e-3*1/sv1 + 1e-3*1/sv2;
end

