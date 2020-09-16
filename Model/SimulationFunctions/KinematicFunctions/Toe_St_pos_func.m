function posToest = Toe_St_pos_func(in1)
%TOE_ST_POS_FUNC
%    POSTOEST = TOE_ST_POS_FUNC(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    23-Sep-2019 18:19:25

%7 Link Flat Foot with Double Support file. Only needs state as inputs, parameters are already substituted in
x1 = in1(1,:);
x2 = in1(2,:);
x3 = in1(3,:);
t2 = cos(x3);
t3 = sin(x3);
posToest = reshape([t2,t3,0.0,0.0,-t3,t2,0.0,0.0,0.0,0.0,1.0,0.0,t2.*(-1.0./5.0)+x1,t3.*(-1.0./5.0)+x2,0.0,1.0],[4,4]);