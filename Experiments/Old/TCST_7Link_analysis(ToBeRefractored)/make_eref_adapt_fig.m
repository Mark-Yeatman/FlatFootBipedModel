initialize;
perturb = zeros(1,16);
perturb(11:end) = 0.4*xi(11:end);
gainratios = diag([0,0,0,1,1,0,1,0]);
kd=0;
[fState,xout,tout,out_extra] = walk2(xi+perturb,5);
plot(tout,out_extra.storage_total);
hold on

kd=1;
k_ref=0;
[fState,xout,tout,out_extra] = walk2(xi+perturb,5);
plot(tout,out_extra.storage_total,'Color',orange,'LineStyle','--')
hold on

k_ref = 10;
[fState,xout,tout,out_extra] = walk2(xi+perturb,5);
plot(tout,out_extra.storage_total,'Color',yellow,'LineStyle','-.')

k_ref = 10000;
[fState,xout,tout,out_extra] = walk2(xi+perturb,5);
plot(tout,out_extra.storage_total,'Color',purple,'LineStyle',':','LineWidth',3)

xlabel('Time (Seconds)');
ylabel('Energy (Joules)');

legend('PD','$k_{ref} = 0$','$k_{ref} = 10$','$k_{ref} = 10000$')
setfigprops;
