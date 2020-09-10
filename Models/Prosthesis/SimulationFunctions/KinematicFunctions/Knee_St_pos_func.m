function posKst = Knee_St_pos_func(in1)
%KNEE_ST_POS_FUNC
%    POSKST = KNEE_ST_POS_FUNC(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    14-Oct-2019 12:19:55

%Prosthesis file. Needs state and parameters as inputs
global flowdata
in2 =  flowdata.Parameters.Biped.asvector;
la = in2(:,10);
ls = in2(:,9);
x1 = in1(1,:);
x2 = in1(2,:);
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
t2 = x3+x4;
t3 = t2+x5;
t4 = cos(t3);
t5 = sin(t3);
posKst = reshape([t4,t5,0.0,0.0,-t5,t4,0.0,0.0,0.0,0.0,1.0,0.0,x1-ls.*sin(t2)-la.*sin(x3),x2+ls.*cos(t2)+la.*cos(x3),0.0,1.0],[4,4]);
