function [Ft,Fn] = ForceTanNorm(slope,Fx,Fy)
%FORCETANNORM Summary of this function goes here
%   Detailed explanation goes here
    R_gf = [cos(slope), -sin(slope); sin(slope), cos(slope)]; %Rotate to ground reference frame
    F_gf = R_gf*[Fx;Fy];
    Ft = F_gf(1); 
    Fn = F_gf(2);
end

