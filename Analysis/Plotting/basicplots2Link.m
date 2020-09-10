%% Colors
blue = [0, 0.4470, 0.7410];
orange = [0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
purple = [0.4940, 0.1840, 0.5560];
green = [0.4660, 0.6740, 0.1880];
red = [0.6350, 0.0780, 0.1840];
dim = flowdata.Parameters.dim;

set(0,'DefaultFigureWindowStyle','docked')
set(0,'DefaultAxesXGrid','on')
set(0,'DefaultAxesYGrid','on')

%% Positions
figure('Name','Positions','NumberTitle','off')
plot(tout,rad2deg(xout(:,3:dim/2)))
title('Joint Positions')
legend("ank","hip",'Location', 'eastoutside')
xlabel('Time (s)')
ylabel('Joint pos (deg)')

%% Velocities
figure('Name','Velocities','NumberTitle','off')
plot(tout,xout(:,dim/2+3:dim))
title('velocities')
legend("ank","hip",'Location', 'eastoutside')

%% Energies
% figure('Name','Energies','NumberTitle','off')
% plot(tout, out_extra.E, tout, out_extra.Eref)
% title('energies')
% legend("E", "Eref",'Location', 'eastoutside')
% xlabel("time")
% ylabel("Energy")

%% Torques
figure('Name','Torques','NumberTitle','off')
plot(tout,out_extra.u(:,3:end))
title('Torques')
legend("ank","hip",'Location', 'eastoutside')
xlabel("time")
ylabel("Torque (N m)")

%% Guards
figure('Name','Guards','NumberTitle','off')
forward = rad2deg(xout(:,3) - flowdata.Parameters.Environment.slope + pi/2);
backward = rad2deg(xout(:,3) - flowdata.Parameters.Environment.slope - pi/2);
plot(tout,forward,tout,backward)
title('Guards')
legend("forward","backward",'Location', 'eastoutside')
yticks(90*[-2,-1,0,1,2])

set(0,'DefaultFigureWindowStyle','normal')
set(0,'DefaultAxesXGrid','off')
set(0,'DefaultAxesYGrid','off')