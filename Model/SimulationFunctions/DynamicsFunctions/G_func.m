function G = G_func(in1)
%G_FUNC
%    G = G_FUNC(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    23-Sep-2019 18:19:23

%7 Link Flat Foot with Double Support file. Only needs state as inputs, parameters are already substituted in
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
x6 = in1(6,:);
x7 = in1(7,:);
x8 = in1(8,:);
t2 = x3+x4;
t3 = sin(t2);
t4 = t2+x5;
t5 = sin(t4);
t6 = t4+x6;
t13 = t3.*2.4236250498e+2;
t7 = sin(t6);
t8 = t6+x7;
t14 = -t13;
t15 = t5.*2.1400042158e+2;
t9 = sin(t8);
t10 = t8+x8;
t16 = -t15;
t17 = t7.*4.106938842000001e+1;
t19 = t7.*4.106938842e+1;
t11 = sin(t10);
t18 = t9.*1.270730502e+1;
t20 = t9.*1.270730502e+1;
t12 = t11.*3.4335e-1;
G = [0.0;5.959575000000001e+2;t5.*(-2.1400042158e+2)+t12+t14+t19+t20-sin(x3).*4.1373675e+1;t12+t14+t16+t19+t20;t12+t16+t17+t18;t12+t17+t18;t12+t18;t12];
