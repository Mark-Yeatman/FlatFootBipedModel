function [c,ceq] = IK_SLIP_pos_con(x,SLIP_xy,pf2)
    %IK_COST Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    x= x(:);
    com_pose = COM_pos_func(x,params);
    com_xy = com_pose(1:2);
    
    SLIP_xy = SLIP_xy(:); %put into columns
    com_xy = com_xy(:);
    e_com_pos = SLIP_xy(1:2)-com_xy;
    e_com_pos = e_com_pos(:);

    toe_sw_pose = Toe_Sw_pos_func(x,params);
    toe_xy = toe_sw_pose(1:2,4);
    pf2 = pf2(:);
    e_toe_pos = toe_xy-pf2;
    e_toe_pos = e_toe_pos(:);
    
    e_pos = [e_com_pos;e_toe_pos];
        
    Js1 = Hip_Jacobian_func(x,params);
    Js1 = Js1(1:3,:);
    Js2 = Hip_Jacobian_func(x,params)-Toe_Sw_Jacobian_func(x,params);
    Js2 = Js2(1:3,:);
    
    sv1 = min(svd(Js1));
    sv2 = min(svd(Js2));
    ceq = e_pos;
    c =[];
end

