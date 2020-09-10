% Colors
blue = [0, 0.4470, 0.7410];
orange = 	[0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
purple = [0.4940, 0.1840, 0.5560];
green = [0.4660, 0.6740, 0.1880];
red = [0.6350, 0.0780, 0.1840];

dim = flowdata.Parameters.dim;

%Trajectories
set(0,'DefaultFigureWindowStyle','docked')

%State positions
figure('Name','Positions','NumberTitle','off')
plot(tout,xout(:,1:dim/2))
title('Positions')
legend("x","y","phi","ank_{st}","knee_{st}","hip","knee_{sw}","ank_{sw}",'Location', 'eastoutside')

%State velocities
figure('Name','Velocities','NumberTitle','off')
plot(tout,xout(:,dim/2+1:dim))
title('Velocities')
legend("x","y,","phi","ank_{st}","knee_{st}","hip","knee_{sw}","ank_{sw}",'Location', 'eastoutside')

%Energies
figure('Name','Energies','NumberTitle','off')
plot(tout, out_extra.MechE, tout,out_extra.MechE - out_extra.Work)
title('Energies')
legend("Mech", "Gen", 'Location', 'eastoutside')
xlabel("time")
ylabel("Energy")

%PD Torques
figure('Name','PD Torques','NumberTitle','off')
plot(tout,out_extra.u_pd(:,4:8))
title('Torques')
legend("ank_{st}","knee_{st}","hip","knee_{sw}","ank_{sw}",'Location', 'eastoutside')
xlabel("time")
ylabel("torque")

% %DSLIP Torques
% figure('Name','DSLIP Torques','NumberTitle','off')
% plot(tout,out_extra.u_dslip(:,4:8))
% title('Torques')
% legend("ank_{st}","knee_{st}","hip","knee_{sw}","ank_{sw}",'Location', 'eastoutside')
% xlabel("time")
% ylabel("torque")

% %Constraint Forces
% formatConstraintForces;
% figure('Name','Constraint Forces','NumberTitle','off')
% plot(tout,CForce)
% title('Torques')
% legend("x","y,","phi","ank_{st}","knee_{st}","hip","knee_{sw}","ank_{sw}",'Location', 'eastoutside')
% xlabel("time")
% ylabel("force/torque")

% %GRF
% formatConstraintForces;
% figure('Name','GRF','NumberTitle','off')
% plot(tout,GForce)
% title('ground Reaction Forces')
% legend("Tangent","Normal",'Location', 'eastoutside')
% xlabel("time")
% ylabel("force")

%Clearances
figure('Name','Clearances','NumberTitle','off')
plot(tout,out_extra.FootClearance)
title('Clearances')
legend("foot",'Location', 'eastoutside')
xlabel("time")
ylabel("Distance")

%CoP 
figure('Name','CoP','NumberTitle','off')
plot(tout,out_extra.COP)
title('CoP in Foot Frame')
xlabel("time")
ylabel("Locatin")

set(0,'DefaultFigureWindowStyle','normal')
% %Limit Cycle Figures
% figure()
% plot(xout(:,4),xout(:,4+8),'Color',blue)
% title('Stance Ankle Phase Portrait')
% xlabel('pos')
% ylabel('vel')
% 
% figure()
% plot(xout(:,5),xout(:,5+8),'Color',orange)
% title('Stance Knee Phase Portrait')
% xlabel('pos')
% ylabel('vel')
% 
% figure()
% plot(xout(:,6),xout(:,6+8),'Color',purple)
% title('Hip Phase Portrait')
% xlabel('pos')
% ylabel('vel')
% 
% %Energy and Storage Figures
% figure()
% plot(tout,Energy_Total(xout),'Color',blue);
% title('Mechanical Energy vs time')
% xlabel('s')
% ylabel('K+P')
% 
% figure()
% plot(tout,out_extra.sys_energy_total,'Color',orange);
% title('Generalized Energy vs time')
% xlabel('s')
% ylabel('K+P')
% 
% figure()
% plot(tout,out_extra.storage_total,'Color',purple);
% title('Storage vs time')
% xlabel('s')
% ylabel('S')
% 
% 
% %Torque and Power Figures
% figure()
% set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
% plot(tout,out_extra.u_pbc(:,4:end));
% title('PBC')
% xlabel('Torque')
% ylabel('Time')
% legend('u_{a}','u_{k}','u_{h}','u_{sw k}','u_{sw a}')
% 
% figure()
% set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
% plot(tout,out_extra.u_pd(:,4:end));
% title('PD')
% xlabel('Time')
% ylabel('Torque')
% legend('u_{a}','u_{k}','u_{h}','u_{sw k}','u_{sw a}')
% 
% figure()
% set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
% plot(tout,xout(:,4+8:end).*out_extra.u_pbc(:,4:end));
% title('PBC Power')
% xlabel('Time')
% ylabel('Power')
% legend('ankle','knee','hip','swing knee','swing ankle')
% 
% figure()
% set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
% plot(tout,out_extra.u_pd(:,4:end) + out_extra.u_pbc(:,4:end));
% title('PD+PBC')
% xlabel('Time')
% ylabel('Torque')
% legend('u_{a}','u_{k}','u_{h}','u_{sw k}','u_{sw a}')
% 
%tilefigs