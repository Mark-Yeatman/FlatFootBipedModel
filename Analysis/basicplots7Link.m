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
figure('Name','Energy','NumberTitle','off')
plot(tout, out_extra.Energy,tout,out_extra.SLIPSubEnergy)
title('Energy')
xlabel("time")
ylabel("Energy")
legend("Total Energy","SubEnergy")

%SLIP related plots
figure('Name','SLIP','NumberTitle','off')
subplot(2,2,1);
plot(out_extra.COMPos(:,1),out_extra.COMPos(:,2))
title('Center of Mass xy')
xlabel("x (meters)")
ylabel("y (meters)")

subplot(2,2,3);
plot(tout,out_extra.COMPos(:,1))
title('COM x')
xlabel("time (seconds)")
ylabel("x (meters)")

subplot(2,2,4);
plot(tout,out_extra.COMPos(:,2))
title('COM y')
xlabel("time (seconds)")
ylabel("y (meters)")

%Center of Pressure
figure('Name','COP','NumberTitle','off')
for i=1:length(out_extra.steps)
   for j=1:length(out_extra.steps{i}.phases)       
        ts = out_extra.steps{i}.phases{j}.t_start;
        te = out_extra.steps{i}.phases{j}.t_end;        
        t = tout((ts<=tout)&(tout<=te));
        t = t(1:length(out_extra.steps{i}.phases{j}.COPFootPos));
        temp = out_extra.steps{i}.phases{j}.COPFootPos;
        temp(temp>100) = nan;
        plot(t,temp,'g');
        hold on
   end
end
title('COP')
xlabel("t (seconds)")
ylabel("COP foot frame (meters)")

%Constraint forces
figure('Name','Lambda','NumberTitle','off')
for i=1:length(out_extra.steps)
   for j=1:length(out_extra.steps{i}.phases)       
        ts = out_extra.steps{i}.phases{j}.t_start;
        te = out_extra.steps{i}.phases{j}.t_end;        
        t = tout((ts<=tout)&(tout<=te));
        t = t(1:length(out_extra.steps{i}.phases{j}.Lambda));
        plot(t,out_extra.steps{i}.phases{j}.Lambda);
        hold on
   end
end
title('Lambda')
xlabel("t (seconds)")
ylabel("\lambda")

set(0,'DefaultFigureWindowStyle','normal')
