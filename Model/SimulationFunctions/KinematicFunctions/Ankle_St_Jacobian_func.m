function js1 = Ankle_St_Jacobian_func(in1)
%ANKLE_ST_JACOBIAN_FUNC
%    JS1 = ANKLE_ST_JACOBIAN_FUNC(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    23-Sep-2019 18:19:31

%7 Link Flat Foot with Double Support file. Only needs state as inputs, parameters are already substituted in
x3 = in1(3,:);
js1 = reshape([1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,cos(x3).*(-7.0./1.0e+2),0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,sin(x3).*(-7.0./1.0e+2),0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],[6,6]);
