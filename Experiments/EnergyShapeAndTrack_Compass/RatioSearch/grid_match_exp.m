%Script for general workflow related to searching for new limit cycles by
%slowly changing system parameters from an initial parameter set and stable cycle

%search for upper limit using a grid search

tic

%Custom setup variables
results_name = 'shape_mass_ratio_epbc';
match_results_name = 'physical_mass_ratio';
params_name = 'Shape';
param_update_script = 'searchShapeMassRatioEPBC';
dosave = true;

step_check_num = 25;
min_speed = 0.1;
walk_e_tol = 1e-6;
w_cyc_max = 5; %-> max number of steps = step_check_num * w_cyc_max 

clear('flowdata','temp_exp_results');
%clear('flowdata')

path(pathdef)
addpath('Experiments\EnergyShapeAndTrack_Compass\')
addpath('Experiments\EnergyShapeAndTrack_Compass\Data')
addpath('Experiments\EnergyShapeAndTrack_Compass\RatioSearch\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

%Initial parameter set and system state
% initializeCompassGaitLimitCycle
% guess = xi;
% run(param_update_script)
% flowdata.Flags.silent = false;
% [fstate, xout, tout, out_extra] = walk(xi,1);
% vector = boolean([0,0,1,1,0,0,1,1]);
% maxeig = max(abs(eigenmap(fstate,1,1,vector)));
% 
% temp_exp_results.center.ratio = ratio;
% temp_exp_results.center.Parameters = flowdata.Parameters.(params_name);
% temp_exp_results.center.State.extra{1} = flowdata.State;
% temp_exp_results.center.State.xi{1} = fstate.*vector;
% temp_exp_results.center.maxeig = maxeig;
% temp_exp_results.center.speed = out_extra.steps{end}.speed;
% temp_exp_results.center.xout = xout;
% temp_exp_results.center.tout = tout;
% temp_exp_results.center.out_extra = out_extra;
% if isfield(flowdata.Parameters, 'KPBC')
%      temp_exp_results.center.Eref = flowdata.Parameters.KPBC.Eref.SSupp;
% end

%Go up and down from start
dirnames = {'up','down'};

%Workflow variables
vector = boolean([0,0,1,1,0,0,1,1]);
last_speed = inf;
stable = true;
done = true;
count = 0;
direction = dirnames{index};
initializeCompassGaitLimitCycle
flowdata.Flags.silent = true;
[fstate, xout, tout, out_extra] = walk(xi,1);
guess = fstate;
flowdata.State.PE_datum = guess(2);
%Loop over system parameters
flowdata.Flags.silent = false;
for i = 1:length(grid_results.(match_results_name).ratio)

    %Get first biped step
    flowdata.Flags.terminate = 0;
    ratio = grid_results.(match_results_name).ratio{i};
    guess = grid_results.(match_results_name).State{i}.xi;
    flowdata.State = grid_results.(match_results_name).State{i}.extra;
    run(param_update_script)
    [fstate, xout, tout, out_extra] = walk(guess,1);
    e_last = norm(fstate(vector) - guess(vector));
    e = e_last;
    done = false;

    if ratio > 0
        fprintf( strcat("\n \n Ratio: " , num2str(ratio),'\n') );
        %Check every 'step_check_num' steps for convergence or failure
        w_cyc_count = 0;
    else
        w_cyc_count = inf;
        stable = false;
    end

    while flowdata.Flags.terminate == 0 && (last_speed > min_speed) && ~done && (e <= e_last) && w_cyc_count < w_cyc_max && ~any(isnan(fstate))
        fprintf("walking...")
        e_last = e;
        %flowdata.Flags.silent = true;
        %disp([num2str(fstate(2)),num2str(flowdata.State.PE_datum)])
        [fstate, xout, tout, out_extra] = walk(fstate, step_check_num);
        e = norm(fstate(vector) - out_extra.istate_plus(end-1,vector) );
        done = e < walk_e_tol && ~any(isnan(fstate));
        last_speed = out_extra.steps{end}.speed; 
        w_cyc_count = w_cyc_count+1;
    end
    fprintf("\n")

    %test stability using linearized poincare section eigenvalues
    if done
        %flowdata.Flags.silent = false;
        [fstate, xout, tout, out_extra] = walk(fstate,1);
        %flowdata.Flags.silent = true;
        fprintf("Checking stability...")
        maxeig = max(abs(eigenmap(fstate,1,1,vector)));
        stable = maxeig < 1; 
    end

    if stable && done
       fprintf(strcat("Stable", "\n"))
       guess = fstate.*vector; %reset value of cyclic variables 
       flowdata.State.PE_datum = 0;
       count = count + 1;

       %Save results
        temp_exp_results.ratio{count} = ratio;
        temp_exp_results.Parameters{count} = flowdata.Parameters.(params_name);
        temp_exp_results.State{count}.extra = flowdata.State;
        temp_exp_results.State{count}.xi = fstate.*vector;
        temp_exp_results.maxeig{count} = maxeig;
        temp_exp_results.speed{count} = out_extra.steps{end}.speed;
        temp_exp_results.xout{count} = xout;
        temp_exp_results.tout{count} = tout;
        temp_exp_results.out_extra{count} = out_extra;
        if isfield(flowdata.Parameters, 'KPBC')
             temp_exp_results.Eref{count} = flowdata.Parameters.KPBC.Eref.SSupp;
        end

    else %unstable
       fprintf(strcat("Unstable", "\n"))
    end
end


%format and save results
match_results.(results_name) = temp_exp_results;
if dosave
    save Experiments\EnergyShapeAndTrack_Compass\Data\match_results match_results
end
toc
disp(strcat(param_update_script, ' is done.'));