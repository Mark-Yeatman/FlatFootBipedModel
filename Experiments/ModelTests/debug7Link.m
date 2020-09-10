clear flowdata
clear flowData
path(pathdef)
addpath('Experiments')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath('Models\7LinkFlatFoot\SSupp')

%Get all the simulations functions
addpath(genpath('Models\7LinkFlatFoot\DSupp'))

%Use the sigle support constraints
rmpath('Models\7LinkFlatFoot\DSupp\SimulationFunctions\ConstraintFunctions\')
addpath('Models\7LinkFlatFoot\SSupp\SimulationFunctions\ConstraintFunctions\')

initialize_SSupp_0x095Slope
flowdata.Flags.do_validation = false;

[fstate_new, xout_new, tout_new, out_extra_new] = walk(xi,1);

clear flowdata
clear flowData
path(pathdef)
cd 7LinkFlatFoot
initialize_SSupp
[fstate_old,xout_old,tout_old,out_extra_old] = walk(xi,1);
cd ..

set(0,'DefaultFigureWindowStyle','docked')
%Joint positions
figure('Name','Joint Pos','NumberTitle','off')
subplot(2,1,1)
plot(tout_old,xout_old(:,3:dim/2),tout_old,xout_old(:,3:dim/2))
title('Old')
legend("phi","ank_{st}","knee_{st}","hip","knee_{sw}","ank_{sw}",'Location', 'eastoutside')

subplot(2,1,2)
plot(tout_new,xout_new(:,1:dim/2))
title('New')
legend("phi","ank_{st}","knee_{st}","hip","knee_{sw}","ank_{sw}",'Location', 'eastoutside')

figure('Name','Overlay','NumberTitle','off')
plot(tout_old,xout_old(:,1:dim/2),tout_new, xout_new(:,1:dim/2))

%COP
figure('Name','COP','NumberTitle','off')
subplot(2,1,1)
plot(tout_old,-out_extra_old.cop_trail,tout_new,out_extra_new.COP)
xlabel("time")
ylabel("Locatin")

set(0,'DefaultFigureWindowStyle','normal')

path(pathdef)
addpath('Experiments')
addpath('Analysis\')
addpath('UtilityFunctions\')