% Colors
blue = [0, 0.4470, 0.7410];
orange = 	[0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
purple = [0.4940, 0.1840, 0.5560];
green = [0.4660, 0.6740, 0.1880];
red = [0.6350, 0.0780, 0.1840];

%Limit Cycle Figures
figure()
plot(xout(:,4),xout(:,4+8),'Color',blue)
title('Stance Ankle Phase Portrait')
xlabel('pos')
ylabel('vel')

figure()
plot(xout(:,5),xout(:,5+8),'Color',orange)
title('Stance Knee Phase Portrait')
xlabel('pos')
ylabel('vel')

figure()
plot(xout(:,6),xout(:,6+8),'Color',purple)
title('Hip Phase Portrait')
xlabel('pos')
ylabel('vel')

%Energy and Storage Figures
figure()
plot(tout,Energy_Total(xout),'Color',blue);
title('Mechanical Energy vs time')
xlabel('s')
ylabel('K+P')

figure()
plot(tout,out_extra.sys_energy_total,'Color',orange);
title('Generalized Energy vs time')
xlabel('s')
ylabel('K+P')

figure()
plot(tout,out_extra.storage_total,'Color',purple);
title('Storage vs time')
xlabel('s')
ylabel('S')


%Torque and Power Figures
figure()
set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
plot(tout,out_extra.u_pbc(:,4:end));
title('PBC')
xlabel('Torque')
ylabel('Time')
legend('u_{a}','u_{k}','u_{h}','u_{sw k}','u_{sw a}')

figure()
set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
plot(tout,out_extra.u_pd(:,4:end));
title('PD')
xlabel('Time')
ylabel('Torque')
legend('u_{a}','u_{k}','u_{h}','u_{sw k}','u_{sw a}')

figure()
set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
plot(tout,xout(:,4+8:end).*out_extra.u_pbc(:,4:end));
title('PBC Power')
xlabel('Time')
ylabel('Power')
legend('ankle','knee','hip','swing knee','swing ankle')

figure()
set(findall(gcf,'-property','Interpreter'),'Interpreter','Latex')
plot(tout,out_extra.u_pd(:,4:end) + out_extra.u_pbc(:,4:end));
title('PD+PBC')
xlabel('Time')
ylabel('Torque')
legend('u_{a}','u_{k}','u_{h}','u_{sw k}','u_{sw a}')

autoArrangeFigures(3,4,1)