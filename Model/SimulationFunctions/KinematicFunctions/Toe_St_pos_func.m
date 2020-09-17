function posToest = Toe_St_pos_func(in1,in2)
%TOE_ST_POS_FUNC
%    POSTOEST = TOE_ST_POS_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    16-Sep-2020 21:44:00

lf = in2(:,7);
x1 = in1(1,:);
x2 = in1(2,:);
x3 = in1(3,:);
t2 = cos(x3);
t3 = sin(x3);
posToest = reshape([t2,t3,0.0,0.0,-t3,t2,0.0,0.0,0.0,0.0,1.0,0.0,x1+lf.*t2,x2+lf.*t3,0.0,1.0],[4,4]);
