function out1 = Hip_Jacobian_func(in1,in2)
%HIP_JACOBIAN_FUNC
%    OUT1 = HIP_JACOBIAN_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    18-Apr-2020 15:46:19

%
ls = in2(:,7);
lt = in2(:,8);
x3 = in1(3,:);
x4 = in1(4,:);
t2 = x3+x4;
t3 = cos(t2);
t4 = sin(t2);
t5 = lt.*t3;
t6 = lt.*t4;
t7 = -t5;
t8 = -t6;
out1 = reshape([1.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,t7-ls.*cos(x3),t8-ls.*sin(x3),0.0,0.0,0.0,t3,t7,t8,0.0,0.0,0.0,t3,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],[6,6]);
