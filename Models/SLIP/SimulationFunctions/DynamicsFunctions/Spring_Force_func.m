function Fval = Spring_Force_func(in1,in2,in3)
%SPRING_FORCE_FUNC
%    FVAL = SPRING_FORCE_FUNC(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    11-Jun-2020 13:17:49

L0 = in3(:,1);
k = in3(:,2);
x1 = in1(1,:);
x2 = in1(2,:);
xf = in2(1,:);
yf = in2(2,:);
Fval = k.*(L0-sqrt((x1-xf).^2+(x2-yf).^2));
