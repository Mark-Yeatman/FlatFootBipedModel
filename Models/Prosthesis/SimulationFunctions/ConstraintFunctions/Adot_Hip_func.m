function Adothip = Adot_Hip_func(in1)
%ADOT_HIP_FUNC
%    ADOTHIP = ADOT_HIP_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    14-Oct-2019 12:19:59

%Prosthesis file. Needs state and parameters as inputs
global flowdata
in2 =  flowdata.Parameters.Biped.asvector;
la = in2(:,10);
ls = in2(:,9);
lt = in2(:,8);
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
x8 = in1(8,:);
x9 = in1(9,:);
x10 = in1(10,:);
t2 = x3+x4;
t3 = x8+x9;
t4 = cos(t2);
t5 = sin(t2);
t6 = t2+x5;
t7 = t3+x10;
t8 = cos(t6);
t9 = sin(t6);
t10 = ls.*t3.*t4;
t11 = ls.*t3.*t5;
t12 = lt.*t7.*t8;
t13 = lt.*t7.*t9;
t14 = -t10;
t15 = -t12;
Adothip = reshape([0.0,0.0,0.0,0.0,t11+t13+la.*x8.*sin(x3),t14+t15-la.*x8.*cos(x3),t11+t13,t14+t15,t13,t15],[2,5]);
