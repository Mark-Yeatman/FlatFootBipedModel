function out1 = A_VHC_func(in1,in2)
%A_VHC_FUNC
%    OUT1 = A_VHC_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    29-May-2020 10:16:53

a = in2(:,4);
b = in2(:,5);
x3 = in1(3,:);
x4 = in1(4,:);
t2 = a+b;
t3 = x3.*2.0;
t5 = x4./2.0;
t4 = t2.^2;
t6 = sin(t5);
out1 = [0.0,0.0,t4.*t6.^2.*sin(t3+x4).*-3.0,(t4.*(sin(x4).*5.0+t6.*cos(t3+x4.*(3.0./2.0)).*6.0))./4.0];
