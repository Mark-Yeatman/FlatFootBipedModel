global param_error_per 
param_error_per  = 1 + 0.3*[-1,-1,1 ,-1,-1,-1,1,1,1,-1,1];

initialize;
gainratios = diag([0,0,0,1,1,0,0,0]);

%colors
blue = [0, 0.4470, 0.7410];
orange = 	[0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
purple = [0.4940, 0.1840, 0.5560];
green = [0.4660, 0.6740, 0.1880];
red = [0.6350, 0.0780, 0.1840];

%accurate, decentralized
kd = 1;
perturb = zeros(1,16);
perturb(11:end) = 0.4*xi(11:end);
Eref_b = [ 5.092636864146643e+02;5.032885594661856e+02;5.064078133352847e+02];
Efunc_b = @Energy_Sub
[fState,xout,tout,out_extra] = walk2(xi+perturb,5); %simulation function call!
plot(tout,out_extra.storage_total,'Color',yellow,'LineStyle','-.')
hold on

%error, decentralized
kd = 1;
Eref_b = [ 5.117040218471509e+02;  5.081455261133219e+02; 5.166072160054176e+02];
Efunc_b = @Energy_Sub_ParamError
[fState,xout,tout,out_extra] = walk2(xi+perturb,5); %simulation function call!
plot(tout,out_extra.storage_total,'Color',green,'LineStyle','--')

%uncontrolled
kd = 0;
[fState,xout,tout,out_extra] = walk2(xi+perturb,5); %simulation function call!
plot(tout,out_extra.storage_total,'Color',blue)

xlabel('Time (Seconds)');
ylabel('Storage (Joules$^2$)');

setfigprops;
legend('No Error','Error')