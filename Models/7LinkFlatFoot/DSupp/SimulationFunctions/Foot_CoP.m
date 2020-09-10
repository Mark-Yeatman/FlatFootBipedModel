function CoP_foot_frame = Foot_CoP(Lambda)
global flowdata
    slope = flowdata.Parameters.Environment.slope;
    la = flowdata.Parameters.Biped.la;
    Fx=-Lambda(1);
    Fy=-Lambda(2);
    M=-Lambda(3);
    rot = [cos(slope), -sin(slope); sin(slope), cos(slope)];
    temp = rot*[Fx;Fy];
    Ft = temp(1); Fn = temp(2);
    CoP_foot_frame = (M-la*Ft)/Fn;
end

