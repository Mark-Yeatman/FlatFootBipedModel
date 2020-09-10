function l2 = Spring_Length_2_func(in1,in2)
%SPRING_LENGTH_2_FUNC
%    L2 = SPRING_LENGTH_2_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    18-Apr-2020 15:46:20

%
ls = in2(:,3);
lt = in2(:,4);
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
x6 = in1(6,:);
t2 = x3+x4+x5;
t3 = t2+x6;
l2 = sqrt((ls.*cos(t3)+lt.*cos(t2)).^2+(ls.*sin(t3)+lt.*sin(t2)).^2);