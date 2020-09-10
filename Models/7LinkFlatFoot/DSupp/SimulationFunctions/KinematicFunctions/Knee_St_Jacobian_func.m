function js2 = Knee_St_Jacobian_func(in1)
%KNEE_ST_JACOBIAN_FUNC
%    JS2 = KNEE_ST_JACOBIAN_FUNC(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    23-Sep-2019 18:19:31

%7 Link Flat Foot with Double Support file. Only needs state as inputs, parameters are already substituted in
x3 = in1(3,:);
x4 = in1(4,:);
t2 = x3+x4;
t3 = cos(t2);
t4 = sin(t2);
t5 = t3.*(1.07e+2./2.5e+2);
t6 = t4.*(1.07e+2./2.5e+2);
t7 = -t5;
t8 = -t6;
js2 = reshape([1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,t7-cos(x3).*(7.0./1.0e+2),0.0,0.0,0.0,0.0,0.0,t7,1.0,0.0,0.0,0.0,0.0,0.0,t8-sin(x3).*(7.0./1.0e+2),0.0,0.0,0.0,0.0,0.0,t8,0.0,0.0,0.0,0.0],[6,6]);
