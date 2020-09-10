function ddCoM = COM_accel_func(in1,in2)
%COM_ACCEL_FUNC
%    DDCOM = COM_ACCEL_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.0.
%    28-Jun-2019 16:51:29

a1 = in2(1,:);
a2 = in2(2,:);
a3 = in2(3,:);
a4 = in2(4,:);
x3 = in1(3,:);
x4 = in1(4,:);
x7 = in1(7,:);
x8 = in1(8,:);
t2 = x7+x8;
t3 = x3+x4;
t4 = sin(t3);
t5 = a3.*5.0;
t6 = a4.*5.0;
t7 = t5+t6;
t8 = x7.^2;
t9 = cos(x3);
t10 = sin(x3);
t11 = cos(t3);
t12 = t2.^2;
ddCoM = [a1-a3.*t9.*(7.0./8.0)-t4.*t12.*(1.0./8.0)+t7.*t11.*(1.0./4.0e1)+t8.*t10.*(7.0./8.0),a2-a3.*t10.*(7.0./8.0)+t4.*t7.*(1.0./4.0e1)-t8.*t9.*(7.0./8.0)+t11.*t12.*(1.0./8.0),0.0];