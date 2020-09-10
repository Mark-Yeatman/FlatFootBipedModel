%% Trajectories

set(0,'DefaultFigureWindowStyle','docked')
dim =4;

%Hip Trajectory
figure('Name','Hip Trajectory','NumberTitle','off')
plot(xout(:,1),xout(:,2))
title('Hip Trajectory')
xlabel('x')
ylabel('y')

%State positions
figure('Name','Positions','NumberTitle','off')
plot(tout,xout(:,1),tout,xout(:,2))
title('Positions')
legend("x","y",'Location', 'eastoutside')

%state velocities
figure('Name','Velocities','NumberTitle','off')
plot(tout,xout(:,dim/2+1:dim))
title('velocities')
legend("x","y",'Location', 'eastoutside')


%% Phase Portraits
figure('Name','X-Y plots','NumberTitle','off')

subplot(2,2,1)
plot(xout(:,2),xout(:,3),'o')
title('Y-Xdot Phase Portrait')
xlabel('y')
ylabel('x_dot')
axis vis3d
grid on

subplot(2,2,2)
plot3(xout(:,2),xout(:,4),xout(:,3),'o')
title('Y-Ydot-Xdot Phase Portrait')
xlabel('y')
ylabel('y_{dot}')
zlabel('x_{dot}')
axis vis3d
grid on

subplot(2,2,3)
plot(xout(:,3),xout(:,4),'o')
title('Xdot-Ydot Phase Portrait')
xlabel('x_{dot}')
ylabel('y_{dot}')
axis vis3d
grid on

subplot(2,2,4)
plot(xout(:,2),xout(:,4),'o')
title('Y-Ydot Phase Portrait')
xlabel('y')
ylabel('y_{dot}')
axis vis3d
grid on


%% Phase Portraits
figure('Name','L-theta plots','NumberTitle','off')

z1out = out_extra.L1thetaCords;
z2out = out_extra.L2thetaCords;

subplot(2,2,1)
plot(z1out(:,1),z1out(:,3),'.',z2out(:,1),z2out(:,3),'.')
title('$L-\dot{L}$ Phase Portrait','Interpreter','latex')
xlabel('$\dot{L}$','Interpreter','latex')
ylabel('$L$','Interpreter','latex')
legend('$L_1$','$L_2$','Interpreter','latex');
grid on

subplot(2,2,2)
plot(rad2deg(z1out(:,4)),rad2deg(z1out(:,2)),'.',rad2deg(z2out(:,4)),rad2deg(z2out(:,2)),'.')
title('$\theta-\dot{\theta}$ Phase Portrait','Interpreter','latex')
xlabel('$\dot{\theta}$ (deg/s)','Interpreter','latex')
ylabel('$\theta$ (deg)','Interpreter','latex')
legend('$\theta_1$','$\theta_2$','Interpreter','latex');
grid on

subplot(2,2,3)
plot(tout,z1out(:,1),'.',tout,z2out(:,1),'.')
title('Spring Lengths')
xlabel("time (s)")
ylabel("L (m)")
legend("L_1","L_2");
grid on

subplot(2,2,4)
plot(tout,rad2deg(z1out(:,2)),'.',tout,rad2deg(z2out(:,2)),'.')
title('Angles')
xlabel("time (s)")
ylabel("\theta (deg)")
legend("\theta_1","\theta_2");
grid on

%% Energy Plots
figure('Name',strcat('Energy'),'NumberTitle','off')
subplot(2,1,1)
plot(tout,out_extra.PotentialEnergy, tout,out_extra.KineticEnergy, tout,out_extra.Spring1Energy,tout,out_extra.Spring2Energy)
title('Energy by Component')
ylabel('Joules')
xlabel('Time')
legend('Potential','Kinetic','Spring1', 'Spring2')

subplot(2,1,2)
plot(tout, out_extra.Energy)
title('Total Energy')
ylabel('Joules')
xlabel('Time')

set(0,'DefaultFigureWindowStyle','normal')
