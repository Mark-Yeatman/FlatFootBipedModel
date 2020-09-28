com_accel = zeros(length(tout),3);
slip_accel = zeros(length(tout),2);
params = flowdata.Parameters.Biped.asvec;
k = flowdata.Parameters.Cntr.k;
d = flowdata.Parameters.Cntr.d;
L0 = flowdata.Parameters.Cntr.L0;
lf = flowdata.Parameters.Biped.lf;
CoP_foot_frame = lf/2;
for i=1:length(tout)
   x = xout(i,:)';
   xdot = dynamics(tout(i),x);
   com_accel(i,:) = COM_accel_func(x,xdot(9:16),params);
   
   com_pos = COM_pos_func(x,params)';
   com_vel = COM_vel_func(x,params)';
    
   v1 = com_pos(1:2)-(x(1:2)+[CoP_foot_frame;0]);
   S = [-k*v1(1);-k*(v1(2)-L0)];
   g = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal];
   D = [-d*com_vel(1);0];
   F = S+g+D;
   slip_accel(i,:) = F/flowdata.Parameters.Biped.MTotal;
end

subplot(1,2,1)
plot(tout,com_accel(:,1),tout,slip_accel(:,1));
title('Accel x')
xlabel("time")
ylabel("accel")
legend("biped com", "slip")

subplot(1,2,2)
plot(tout,com_accel(:,2),tout,slip_accel(:,2));
title('Accel y')
xlabel("time")
ylabel("accel")
legend("biped com", "slip")