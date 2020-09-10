%make sure to set control energy parameters to b/2 in dynamics2 and step2
initialize;
gainratios = diag([0,0,0,1,1,0,0,0]);

%colors
blue = [0, 0.4470, 0.7410];
orange = 	[0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
purple = [0.4940, 0.1840, 0.5560];
green = [0.4660, 0.6740, 0.1880];
red = [0.6350, 0.0780, 0.1840];

%uncontrolled
kd = 0;
perturb = zeros(1,16);
perturb(11:end) = 0.4*xi(11:end);
[fState,xout,tout,out_extra] = walk2(xi+perturb,5); %simulation function call!
plot(tout,out_extra.storage_total,'Color',blue)
hold on

%centralized
kd = 1;
Eref_b = [4.600056699405806e+02; 4.643263254745372e+02; 4.560139273082979e+02];
Efunc_b = @Energy_Total
[fState,xout,tout,out_extra] = walk2(xi+perturb,5); %simulation function call!
plot(tout,out_extra.storage_total,'Color',orange,'LineStyle','--')

%decentralized
Eref_b = [ 5.092636864146643e+02;5.032885594661856e+02;5.064078133352847e+02];
Efunc_b = @Energy_Sub
[fState,xout,tout,out_extra] = walk2(xi+perturb,5); %simulation function call!
plot(tout,out_extra.storage_total,'Color',yellow,'LineStyle','-.')

%prosthesis
Eref_b = [12.276974255783596;11.680585696493461; 12.325982058788670];
Efunc_b = @Energy_Pros
[fState,xout,tout,out_extra] = walk2(xi+perturb,5); %simulation function call!
plot(tout,out_extra.storage_total,'Color',purple,'LineStyle',':')

xlabel('Time (Seconds)');
ylabel('Storage (Joules$^2$)');

setfigprops;
legend('PD','U  (PBC)','U_{\zeta} (PBC)','U_{\xi} (PBC)')