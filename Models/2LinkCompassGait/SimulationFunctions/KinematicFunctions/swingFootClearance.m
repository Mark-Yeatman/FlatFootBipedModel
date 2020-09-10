function dist = swingFootClearance(x)
%SWINGFOOTCLEARANCE Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    params = cell2mat(flowdata.Parameters.Biped.values);
    R_gf = flowdata.getRgf;
    foot_sw_vec = R_gf*(Foot_Sw_pos_func(x,params)-Foot_St_pos_func(x,params));
    dist = foot_sw_vec(2,4);
end

