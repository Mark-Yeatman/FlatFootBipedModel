function posCoM = COM_pos_func(in1)
%COM_POS_FUNC
%    POSCOM = COM_POS_FUNC(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    23-Sep-2019 18:19:27

%7 Link Flat Foot with Double Support file. Only needs state as inputs, parameters are already substituted in
x1 = in1(1,:);
x2 = in1(2,:);
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
x6 = in1(6,:);
x7 = in1(7,:);
x8 = in1(8,:);
t2 = x3+x4;
t3 = t2+x5;
t4 = t3+x6;
t5 = t4+x7;
t6 = t5+x8;
posCoM = [x1-sin(t2).*4.066774979423868e-1-sin(t3).*3.590867160493827e-1+sin(t4).*6.891328395061729e-2+sin(t5).*2.132250205761317e-2+sin(t6).*5.761316872427984e-4-sin(x3).*6.94238683127572e-2,x2+cos(t2).*4.066774979423868e-1+cos(t3).*3.590867160493827e-1-cos(t4).*6.891328395061729e-2-cos(t5).*2.132250205761317e-2-cos(t6).*5.761316872427984e-4+cos(x3).*6.94238683127572e-2,0.0];
