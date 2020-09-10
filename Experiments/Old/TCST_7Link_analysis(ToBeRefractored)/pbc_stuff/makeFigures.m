%No saturation
%gainratios = diag([0,0,0,8,3,0.01,3,8]);
%% System energy vs time for non-PBC
    initialize;
    
    %no PBC
    kd=0;
    save pbcgain kd
    clear dynamics2
    [~,hState,~] = walk2(xi,30); %final state, state history, impact states
    t = hState(:,1);
    x = hState(:,2:2+15);
    W = hState(:,end-1);
    ME = PE_Func(x(:,1:end/2))+KE_Func(x(:,1:end/2),x(:,end/2+1:end));

    plot(t, ME - W);
    title('\textbf{System Energy on the Limit Cycle}','Interpreter','latex')
    xlabel('Time (Seconds)','Interpreter','latex')
    ylabel('System Energy (Joules)','Interpreter','latex')
    %change font size
    %saveas(gcf,'SysEn_Nom','epsc')
        
%% Storage function of PBC and non-PBC vs time 
    perturb = zeros(size(xi));
    perturb(11:end) = 0.3*xi(11:end);
    
    kd=0;
    save pbcgain kd
    clear dynamics2
    
    [~,hState,~] = walk2(xi+perturb,5); %final state, state history, impact states
    t = hState(:,1);
    S1 = hState(:,end);
    
    figure
    hold on
    plot(t, S1);
    title('\textbf{Storage Function vs Time}','Interpreter','latex')
    xlabel('Time (Seconds)','Interpreter','latex')
    ylabel('Storage','Interpreter','latex')
   
    %Turn on PBC
    kd=0.1;
    save pbcgain kd
    clear dynamics2
    
    [~,hState,~] = walk2(xi+perturb,5); %final state, state history, impact states
    t = hState(:,1);
    S2 = hState(:,end);
    
    plot(t, S2);
    legend('no PBC', 'w/ PBC')
%% Phase portrait of perturbed PBC convergence
    perturb(11:end) = 0.4*xi(11:end);
    
    kd=0.25;
    save pbcgain kd
    clear dynamics2
    
    [~,hState,~] = walk2(xi+perturb,5); %final state, state history, impact states
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
    
%% Same system/portrait non-PBC unstable
    kd=0;
    save pbcgain kd
    clear dynamics2

    [~,hState,~] = walk2(xi+perturb,5); %final state, state history, impact states
    t = hState(:,1);
    x = hState(:,2:2+15);
    ME = PE_Func(x(:,1:end/2))+KE_Func(x(:,1:end/2),x(:,end/2+1:end));
    phi = x(:,3)+x(:,4)+x(:,5);
    
    open NomLimCycle.fig
    hold on
    temp1 = xlim;
    temp2 = ylim;
    plot(phi,ME)
    xlim(temp1)
    ylim(temp2)
    title('\textbf{Perturbed Limit Cycle no PBC}','Interpreter','latex')
    xlabel('Phase','Interpreter','latex')
    ylabel('Mechanical Energy (Joules)','Interpreter','latex')
    legend('Limit Cycle' , 'Dist Traj')

%% Phase portrait different slope PBC convergence
    slope = 0.12;
    
    kd=0.25;
    save pbcgain kd
    clear dynamics2
      
    [fState,hState,~] = walk2(xi,20); %final state, state history, impact states
    x = hState(:,2:2+15);
    ME = PE_Func(x(:,1:end/2))+KE_Func(x(:,1:end/2),x(:,end/2+1:end));
    phi = x(:,3)+x(:,4)+x(:,5);
    
    open NomLimCycle.fig
    hold on
    plot(phi,ME)
    title('\textbf{$\Delta \alpha$ Limit Cycle with PBC}','Interpreter','latex')
    xlabel('Phase','Interpreter','latex')
    ylabel('Mechanical Energy (Joules)','Interpreter','latex')

    
    kd=1;
    save pbcgain kd
    clear dynamics2
    
    [fState,hState,~] = walk2(xi,20); %final state, state history, impact states
    x = hState(:,2:2+15);
    ME = PE_Func(x(:,1:end/2))+KE_Func(x(:,1:end/2),x(:,end/2+1:end));
    phi = x(:,3)+x(:,4)+x(:,5);
    plot(phi,ME)
    legend('Limit Cycle' , 'k = 0.25' , ' k =1')
    
%% Same system/portrait non-PBC unstable different slope  
    kd=0;
    save pbcgain kd
    clear dynamics2
    
    %use controlled end state to show it falls without
    [~,hState,~] = walk2(fState,10); %final state, state history, impact states
    x = hState(:,2:2+15);
    ME = PE_Func(x(:,1:end/2))+KE_Func(x(:,1:end/2),x(:,end/2+1:end));
    phi = x(:,3)+x(:,4)+x(:,5);
    
    open NomLimCycle.fig
    hold on
    plot(phi,ME)
    title('\textbf{$\Delta \alpha$ Limit Cycle no PBC}','Interpreter','latex')
    xlabel('Phase','Interpreter','latex')
    ylabel('Mechanical Energy (Joules)','Interpreter','latex')
    legend('Limit Cycle' , 'Dist Traj')   
    
%% bump all line thicknesses
    %set( findobj(gca,'type','line'), 'LineWidth', 5);