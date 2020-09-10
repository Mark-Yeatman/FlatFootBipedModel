function dist = swingFootClearance(x)
%SWINGFOOTCLEARANCE Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    R_gf = flowdata.getRgf;
    foot_sw_vec = R_gf*(Foot_Sw_pos_func(x)-Foot_St_pos_func(x));
    dist = foot_sw_vec(2,4);
end

