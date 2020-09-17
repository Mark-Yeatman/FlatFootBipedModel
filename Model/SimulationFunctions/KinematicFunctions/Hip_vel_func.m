function velH = Hip_vel_func(in1,in2)
%HIP_VEL_FUNC
%    VELH = HIP_VEL_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    16-Sep-2020 21:44:04

la = in2(:,8);
ls = in2(:,6);
lt = in2(:,5);
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
x9 = in1(9,:);
x10 = in1(10,:);
x11 = in1(11,:);
x12 = in1(12,:);
x13 = in1(13,:);
t2 = x3+x4;
t3 = x11+x12;
t4 = t2+x5;
t5 = t3+x13;
t6 = cos(t4);
t7 = sin(t4);
t8 = t5.*t6;
t9 = t5.*t7;
t10 = -t9;
velH = reshape([t10,t8,0.0,0.0,-t8,t10,0.0,0.0,0.0,0.0,0.0,0.0,x9-lt.*t8-ls.*t3.*cos(t2)-la.*x11.*cos(x3),x10+lt.*t10-ls.*t3.*sin(t2)-la.*x11.*sin(x3),0.0,0.0],[4,4]);
