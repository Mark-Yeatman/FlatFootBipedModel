function u = Holonomic(x)
    %HOLONOMIC A holonomic controller that drives the swing leg trajectory of a
    %4 link robot
    %   
    %   Uses a fit of winters data parameterized by global hip angle
    global flowdata
    
    dim = flowdata.Parameters.dim;
       
    u = zeros(dim/2,1);  
    if strcmp(flowdata.State.c_phase,"SSupp")
        
        %Winters Data Arrays
        a_knee=[-21.9472500000000,4.24525000000000,21.6720000000000,0;20.9295000000000,-6.97650000000000,7.71900000000000,0;15.9362500000000,-0.998250000000000,18.6640000000000,25.8830000000000;-59.8412500000000,13.6422500000000,64.8630000000000,0;-19.4405000000000,-1.40250000000000,38.4100000000000,-47.2960000000000;45.1070000000000,-7.15300000000000,0.456000000000000,0;1.42525000000000,0.0657500000000000,2.21000000000000,3.24500000000000];
        a_ankle=[5.50050000000000,-0.880500000000000,-4.60000000000000,0;-8.98500000000000,3.77020000000000,5.26600000000000,4.65120000000000;0.812500000000000,-0.475000000000000,7.74100000000000,2.81250000000000;-2.19975000000000,0.320750000000000,9.62000000000000,0;-14.7575000000000,0.878500000000001,-0.745000000000000,-24.2440000000000;23.0932000000000,-3.91420000000000,-19.9240000000000,0;-29.8020000000000,9.93400000000000,-0.0560000000000000,0;0.703500000000000,-0.234500000000000,-0.525000000000000,0;-2.60850000000000,0.869500000000000,1.21400000000000,0;-0.729000000000000,0.0190000000000000,0.580000000000000,-1.34400000000000];
        knee_ind=[1 139 400 530 720 848 976 1001];
        ankle_ind=[1 61 205 330 440 550 653 846 898 977 1001];

        q = x(1:dim/2);
        qdot = x(dim/2+1:dim);
        
        hip_pos = rad2deg(q(3)+q(4)+q(5));
        
        Hip_Pos_Max = 23; %degrees
        Hip_Pos_Min = -20; %degrees
        phase_var_out =  0.6 + 0.4*(hip_pos-Hip_Pos_Min)/(Hip_Pos_Max-Hip_Pos_Min);
        phase_var_out = clamp(phase_var_out,0.6,1);
        
        [knee_des_out ,~,ankle_des_out,~]=winterFit(phase_var_out*1000,a_knee,a_ankle,knee_ind,ankle_ind);
        
        knee_des_out = - knee_des_out; %convert from biomechanics frame to robot frame
        
        Kp = flowdata.Parameters.Holonomic.Kp;
        Kd = flowdata.Parameters.Holonomic.Kd;
        
        u(6) = -Kp*(q(6)-deg2rad(knee_des_out)) - Kd*qdot(6); %This only track position with a simple damper on velocity. 
        
    end
end

function y = clamp(x,x1,x2)
y=min(x,max(x1,x2));
y=max(y,min(x1,x2));
end

function [knee_r,dknee_r,ankle_r,dankle_r] = winterFit(n,a_knee,a_ankle,knee_ind,ankle_ind)
m1=2;
m2=6;

c_n_knee=n-knee_ind;
j_knee=length(c_n_knee(c_n_knee>=0));
x=(n-knee_ind(j_knee))/(knee_ind(j_knee+1)-knee_ind(j_knee));
knee_r=a_knee(j_knee,1)*(x-1).^m1+a_knee(j_knee,2)*(x-1).^m2+a_knee(j_knee,4)*(x-1)+a_knee(j_knee,3);
dknee_r=(m1*a_knee(j_knee,1)*(x-1).^(m1-1)+m2*a_knee(j_knee,2)*(x-1).^(m2-1)+a_knee(j_knee,4))/(knee_ind(j_knee+1)-knee_ind(j_knee));

c_n_ankle=n-ankle_ind;
j_ankle=length(c_n_ankle(c_n_ankle>=0));
x=(n-ankle_ind(j_ankle))/(ankle_ind(j_ankle+1)-ankle_ind(j_ankle));
ankle_r=a_ankle(j_ankle,1)*(x-1).^m1+a_ankle(j_ankle,2)*(x-1).^m2+a_ankle(j_ankle,4)*(x-1)+a_ankle(j_ankle,3);
dankle_r=(m1*a_ankle(j_ankle,1)*(x-1).^(m1-1)+m2*a_ankle(j_ankle,2)*(x-1).^(m2-1)+a_ankle(j_ankle,4))/(ankle_ind(j_ankle+1)-ankle_ind(j_ankle));

end

% function u = Holonomic(x)
%     %HOLONOMIC A holonomic controller that drives the swing leg trajectory of a
%     %4 link robot
%     %   
%     global flowdata
%     
%     dim = flowdata.Parameters.dim;
%     
%     u = zeros(dim/2,1);  
%     if strcmp(flowdata.State.c_phase,"SSupp")
%         q = x(1:dim/2);
%         qdot = x(dim/2+1:dim);
% 
%         u_slip = SLIP(x);
% 
%         [z,zdot,A,Adot] = getHolonomicConstraint(x);
% 
%         Kp = flowdata.Parameters.Holonomic.Kp;
%         Kd = flowdata.Parameters.Holonomic.Kd;
%         B = flowdata.Parameters.Holonomic.B;
%         M = M_func(x);
%         Bh = A*(M\B);
% 
%         v = -Adot*qdot - (A/M)*(u_slip-C_func(x)*qdot-G_func(x)) -Kd*zdot - Kp*z;
% 
%         W = eye(rank(B));
% 
%         u = B*((W\Bh')/(Bh*(W\Bh')))*(v);
%     end
% end