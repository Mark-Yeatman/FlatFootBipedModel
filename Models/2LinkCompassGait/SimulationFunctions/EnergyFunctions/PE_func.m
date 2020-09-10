function Pe = PE_func(in1,in2)
%PE_FUNC
%    PE = PE_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    29-May-2020 10:16:54

Mh = in2(:,2);
Ms = in2(:,3);
a = in2(:,4);
b = in2(:,5);
g = in2(:,6);
x2 = in1(2,:);
x3 = in1(3,:);
x4 = in1(4,:);
t2 = a+b;
Pe = g.*(x2.*(Mh+Ms.*2.0)+cos(x3).*(Mh.*t2+Ms.*(b+t2))-Ms.*a.*cos(x3+x4));