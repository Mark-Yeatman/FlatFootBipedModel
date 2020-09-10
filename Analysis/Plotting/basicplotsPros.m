%% Colors
blue = [0, 0.4470, 0.7410];
orange = [0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
purple = [0.4940, 0.1840, 0.5560];
green = [0.4660, 0.6740, 0.1880];
red = [0.6350, 0.0780, 0.1840];
dim = flowdata.Parameters.dim;

set(0,'DefaultAxesXGrid','on')
set(0,'DefaultAxesYGrid','on')
set(0,'DefaultFigureWindowStyle','docked')

%% Positions
figure('Name','Positions','NumberTitle','off')
subplot(1,1,1)
plot(tout,rad2deg(xout(:,4:dim/2)))
title('Joint Positions (degrees)')
legend("knee","ankle",'Location', 'eastoutside')

% subplot(2,1,2)
% HipPos = zeros(length(xout),2);
% for i=1:length(xout)
%    temp = Hip_pos_func(xout(i,:)');
%    HipPos(i,:) = temp(1:2,4);
% end
% plot(HipPos(:,1),HipPos(:,2))
% title('Hip Trajectory')

%% Velocities
figure('Name','Velocities','NumberTitle','off')
plot(tout, rad2deg(xout(:,9:10)))
title('velocities (degree/s)')
legend("knee","ankle",'Location', 'eastoutside')

%% Energies
figure('Name','Energies','NumberTitle','off')
subplot(2,1,1)
plot(tout, out_extra.E)
title('energies')
%legend("Mech", "Gen",'Location', 'eastoutside')
xlabel("time")
ylabel("Energy")

subplot(2,1,2)
plot(tout, out_extra.W)
title('Work')
%legend("Mech", "Gen",'Location', 'eastoutside')
xlabel("time")
ylabel("Energy")

%% Torques
figure('Name','Torques','NumberTitle','off')
subplot(3,2,1)
plot(tout,squeeze(out_extra.u(1,:,4:end)))
title('SLIP Torques')
legend("knee","ankle",'Location', 'eastoutside')
xlabel("time")
ylabel("N m")

subplot(3,2,2)
plot(tout,squeeze(out_extra.u(2,:,4:end)))
title('Hard Stop Torques')
legend("knee","ankle",'Location', 'eastoutside')
xlabel("time")
ylabel("N m")

subplot(3,2,3)
plot(tout,squeeze(out_extra.u(3,:,4:end)))
title('PD Torques')
legend("knee","ankle",'Location', 'eastoutside')
xlabel("time")
ylabel("N m")

subplot(3,2,4)
plot(tout,squeeze(out_extra.u(4,:,4:end)))
title('Shaping Torques')
legend("knee","ankle",'Location', 'eastoutside')
xlabel("time")
ylabel("N m")

subplot(3,2,5)
plot(tout,squeeze(out_extra.u(5,:,4:end)))
title('KPBC Torques')
legend("knee","ankle",'Location', 'eastoutside')
xlabel("time")
ylabel("N m")

set(0,'DefaultFigureWindowStyle','normal')
set(0,'DefaultAxesXGrid','off')
set(0,'DefaultAxesYGrid','off')