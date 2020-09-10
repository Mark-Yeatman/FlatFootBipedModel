function js0 = Knee_St_Jacobian_func(in1,in2)
%KNEE_ST_JACOBIAN_FUNC
%    JS0 = KNEE_ST_JACOBIAN_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    29-Jan-2020 14:51:40

%Prosthesis file. Needs state and parameters as inputs
x3 = in1(3,:);
js0 = reshape([1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,cos(x3),0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0],[6,6]);
