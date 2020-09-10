function [Ft,Fn] = ForceTanNorm(slope,Fx,Fy)
%FORCETANNORM Summary of this function goes here
%   Detailed explanation goes here
    rot = [cos(slope), -sin(slope); sin(slope), cos(slope)];
    temp = rot*[Fx;Fy];
    Ft = temp(1); Fn = temp(2);
end

