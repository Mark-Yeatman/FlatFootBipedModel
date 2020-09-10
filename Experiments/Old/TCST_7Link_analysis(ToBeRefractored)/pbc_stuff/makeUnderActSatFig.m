%gainratios = diag([0,0,0,1,0,0,0,1]);
%satU = 100;
perturb(11:end) = 0.4*xi(11:end);
kd=1;
save pbcgain kd
clear dynamics2
[~,hState,~] = walk2(xi+perturb,20); %final state, state history, impact states
t = hState(:,1);
x = hState(:,2:2+15);
W = hState(:,end-1);
ME = PE_Func(x(:,1:end/2))+KE_Func(x(:,1:end/2),x(:,end/2+1:end));
phi = x(:,3)+x(:,4)+x(:,5);
open NomLimCycle.fig
hold on
plot(phi,ME)
title('\textbf{Perturbed Limit Cycle with PBC}','Interpreter','latex')
xlabel('Phase','Interpreter','latex')
ylabel('Mechanical Energy (Joules)','Interpreter','latex')
legend('Limit Cycle' , 'Dist Traj')