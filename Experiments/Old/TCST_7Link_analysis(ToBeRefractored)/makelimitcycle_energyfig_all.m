%make sure to set control energy parameters to b/2 in dynamics2 and step2
initialize;

%colors
blue = [0, 0.4470, 0.7410];
orange = 	[0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
purple = [0.4940, 0.1840, 0.5560];
green = [0.4660, 0.6740, 0.1880];
red = [0.6350, 0.0780, 0.1840];

%get centralized and decentralized
kd = 0;
[fState,xout,tout,out_extra] = walk2(xi,3); %simulation function call!
plot(tout,out_extra.sys_energy_total,'Color',orange,'LineStyle','--')
hold on
plot(tout,out_extra.sys_energy_partial,'Color',yellow,'LineStyle','-.')

%get prosthesis
Efunc_b = @Energy_Pros;
[fState,xout,tout,out_extra] = walk2(xi,3); %simulation function call!
hold on
l1 = plot(tout,out_extra.sys_energy_partial,'Color',purple,'LineStyle',':');

xlabel('Time (Seconds)');
ylabel('Energy (Joules)');
xlim([0,1.65])
legend('U  (PBC)','U_{\zeta} (PBC)','U_{\xi} (PBC)')
setfigprops;
plotinfo = breakyaxis([15,450]);
plotinfo.lowAxes.YLim = [10,15];
l1.LineWidth = 4;