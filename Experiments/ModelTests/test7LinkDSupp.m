clear all

path(pathdef)
addpath('Experiments\ModelTests\')
addpath('Analysis\')
addpath('UtilityFunctions\')

%Get all the simulations functions
addpath(genpath('Models\7LinkFlatFoot\DSupp'))

initialize_DSupp_0x095Slope

%custom setup
%flowdata.E_func = @Energy_Sub;
flowdata.Flags.do_validation = false;
xtest = xi;

walk(xtest,3);

% %find reference energies
% if norm(out_extra.steps{end-1}.steplength - out_extra.steps{end}.steplength) < 1e-8
%     iHeel = find(tout == out_extra.steps{end}.phases{1}.tstart,1,'last');
%     iFlat = find(tout == out_extra.steps{end}.phases{2}.tstart,1,'last');
%     iToe  = find(tout == out_extra.steps{end}.phases{3}.tstart,1,'last');
%     ErefHeel = out_extra.MechE(iHeel)
%     ErefFlat = out_extra.MechE(iFlat)
%     ErefToe = out_extra.MechE(iToe)
% end

[fstate, xout, tout, out_extra] = walk(xtest,1);
videopath = 'Experiments\Videos\';
animate(@draw7Link,xout,tout,out_extra,0.2,strcat(videopath,'test7LinkDSupp'))