
set(0,'DefaultAxesXGrid','on')
set(0,'DefaultAxesYGrid','on')
set(0,'DefaultFigureWindowStyle','docked')

figure('Name','Phase Portrait','NumberTitle','off')
plot(xout(:,4),xout(:,2))
hold on
limits = axis;
h = flowdata.Parameters.Environment.h;
plot([limits(1),0],[0,0],'r--','LineWidth',3)
%plot([0,limits(2)],[h,h],'g--','LineWidth',3)
title("Phase Portrait")
xlabel('$\dot{y}$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('Trajectory','Switching Surface')
axis equal

figure('Name','Trajectories','NumberTitle','off')
plot(tout, xout(:,2))
xlabel('time')
ylabel("y")

figure('Name','Energies','NumberTitle','off')
plot(tout, out_extra.E)
legend("E")
xlabel('time')
ylabel("Energy (Joules)")

figure('Name','Torque','NumberTitle','off')
subplot(3,1,1)
title("Net Force")
plot(tout, out_extra.u)
legend("x","y")
xlabel('time')
ylabel("Force (N)")

subplot(3,1,2)
title("Force Components")
plot(tout, vecnorm(squeeze(out_extra.Force(1,:,:))), tout, vecnorm(squeeze(out_extra.Force(2,:,:))) )
legend("Spring-Gravity","Energy Tracking")
xlabel('time')
ylabel("Force (N)")

% subplot(3,1,3)
% title("KPBC Force")
% plot(tout, squeeze(out_extra.Force(2,:,:)) )
% legend("x","y")
% xlabel('time')
% ylabel("Force (N)")

set(0,'DefaultFigureWindowStyle','normal')
set(0,'DefaultAxesXGrid','off')
set(0,'DefaultAxesYGrid','off')