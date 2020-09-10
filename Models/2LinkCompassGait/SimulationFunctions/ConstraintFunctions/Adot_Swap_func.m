function Adotswap = Adot_Swap_func(in1,in2)
%ADOT_SWAP_FUNC
%    ADOTSWAP = ADOT_SWAP_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    29-May-2020 10:16:53

a = in2(:,4);
b = in2(:,5);
x3 = in1(3,:);
x4 = in1(4,:);
x7 = in1(7,:);
x8 = in1(8,:);
t2 = a+b;
t3 = x3+x4;
t4 = x7+x8;
t5 = cos(t3);
t6 = sin(t3);
Adotswap = reshape([0.0,0.0,0.0,0.0,-t2.*(t4.*t6-x7.*sin(x3)),t2.*(t4.*t5-x7.*cos(x3)),-t2.*t4.*t6,t2.*t4.*t5],[2,4]);
