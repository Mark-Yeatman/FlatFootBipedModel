function [dist, vel] = swingFootClearance(x)
%SWINGFOOTCLEARANCE Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    R_gf = flowdata.getRgf;
    params = cell2mat(flowdata.Parameters.Biped.values);
    foot_sw_vec = R_gf*(Foot_Sw_pos_func(x,params)-Foot_St_pos_func(x,params));
    foot_sw_vec_vel = R_gf*(Foot_Sw_vel_func(x,params)-Foot_St_vel_func(x,params));
    dist = foot_sw_vec(2,4);
    vel = foot_sw_vec_vel(2,4);
end

