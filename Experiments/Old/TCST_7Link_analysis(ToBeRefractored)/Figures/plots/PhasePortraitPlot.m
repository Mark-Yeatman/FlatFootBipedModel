clc; clear all; close all

load PassivePhasePortrait.mat
x_passive=x;

load PlusPhasePortrait.mat % K=4, mi=1.2
x_plus=x;

load MinusPhasePortrait.mat % K=0.5,mi=0.85
x_minus=x;

% Phi

figure (1)
axis tight
hold on; box off;
z1=plot(x_passive(1:end,3), x_passive(1:end,11),'-r','LineWidth',2);
z2=plot(x_plus(1:end,3),x_plus(1:end,11),':b','LineWidth',2);
z3=plot(x_minus(1:end,3), x_minus(1:end,11),'-.k','LineWidth',2);
x_handle = xlabel('$\Phi$ [rad]');
y_handle = ylabel('$\dot{\Phi}$ [rad/s]');
set(x_handle,'Interpreter','latex','FontSize',20);
set(y_handle,'Interpreter','latex','FontSize',20);
set(gca,'fontsize',20)

% Stance Ankle

figure (2)
axis tight
hold on; box off;
z4=plot(x_passive(1:end,4), x_passive(1:end,12),'-r','LineWidth',2);
z5=plot(x_plus(1:end,4),x_plus(1:end,12),':b','LineWidth',2);
z6=plot(x_minus(1:end,4), x_minus(1:end,12),'-.k','LineWidth',2);
x_handle = xlabel('$\theta_{\mathrm{a}}$ [rad]');
y_handle = ylabel('$\dot{\theta}_{\mathrm{a}}$ [rad/s]');
set(x_handle,'Interpreter','latex','FontSize',20);
set(y_handle,'Interpreter','latex','FontSize',20);
legend_handle=legend({'Passive','$\kappa=4,\mu=1.2$','$\kappa=0.5,\mu=0.85$'},'FontSize',20);
set(legend_handle,'Interpreter','latex','FontSize',20);
set(gca,'fontsize',20)

% Stance Knee
figure (3)
axis tight
hold on; box off;
z7=plot(x_passive(1:end,5), x_passive(1:end,13),'-r','LineWidth',2);
z8=plot(x_plus(1:end,5),x_plus(1:end,13),':b','LineWidth',2);
z9=plot(x_minus(1:end,5), x_minus(1:end,13),'-.k','LineWidth',2);
x_handle = xlabel('$\theta_{\mathrm{k}}$ [rad]');
y_handle = ylabel('$\dot{\theta_{\mathrm{k}}}$ [rad/s]');
set(x_handle,'Interpreter','latex','FontSize',20);
set(y_handle,'Interpreter','latex','FontSize',20);
set(gca,'fontsize',20) 

% Hip
figure (4)
axis tight
hold on; box off;
z10=plot(x_passive(1:end,6), x_passive(1:end,14),'-r','LineWidth',2);
z11=plot(x_plus(1:end,6),x_plus(1:end,14),':b','LineWidth',2);
z12=plot(x_minus(1:end,6), x_minus(1:end,14),'-.k','LineWidth',2);
x_handle = xlabel('$\theta_{\mathrm{h}}$ [rad]');
y_handle = ylabel('$\dot{\theta_{\mathrm{h}}}$ [rad/s]');
set(x_handle,'Interpreter','latex','FontSize',20);
set(y_handle,'Interpreter','latex','FontSize',20);
set(gca,'fontsize',20)

% Swing Knee
figure (5)
 axis tight

hold on; box off;
z13=plot(x_passive(1:end,7), x_passive(1:end,15),'-r','LineWidth',2);
z14=plot(x_plus(1:end,7),x_plus(1:end,15),':b','LineWidth',2);
z15=plot(x_minus(1:end,7), x_minus(1:end,15),'-.k','LineWidth',2);
x_handle = xlabel('$\theta_{\mathrm{sk}}$ [rad]');
y_handle = ylabel('$\dot{\theta_{\mathrm{sk}}}$ [rad/s]');
set(x_handle,'Interpreter','latex','FontSize',20);
set(y_handle,'Interpreter','latex','FontSize',20);
set(gca,'fontsize',20)

% Swing Ankle
figure (6)
 axis tight

hold on; box off;
z16=plot(x_passive(1:end,8), x_passive(1:end,16),'-r','LineWidth',2);
z17=plot(x_plus(1:end,8),x_plus(1:end,16),':b','LineWidth',2);
z18=plot(x_minus(1:end,8), x_minus(1:end,16),'-.k','LineWidth',2);
x_handle = xlabel('$\theta_{\mathrm{sa}}$ [rad]');
y_handle = ylabel('$\dot{\theta_{\mathrm{sa}}}$ [rad/s]');
set(x_handle,'Interpreter','latex','FontSize',20);
set(y_handle,'Interpreter','latex','FontSize',20);
set(gca,'fontsize',20)


tilefigs;

