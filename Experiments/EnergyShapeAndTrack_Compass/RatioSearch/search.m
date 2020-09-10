%Script for general workflow related to searching for new limit cycles by
%slowly changing system parameters from an initial parameter set and stable
%cycle
tic
%search for upper limit using a sort of golden ratio search
c = 1.61803398875; %the golden ratio

%Custom setup variables
results_name = 'search_physical_mass_ratio';
params_name = 'Biped';
param_update_script = 'searchPhysicalMassRatio';
dosave = true;
load("Experiments\EnergyShapeAndTrack_Compass\Data\search_results")

%ratio_start = 2;
ratio_start = 0.771273402609965;
step_size_start = 0.025/c;
step_tol = 0.01;
max_step = 100;

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
ratio = ratio_start;
initializeCompassGaitLimitCycle
guess = xi;
run(param_update_script)
flowdata.Flags.silent = false;
[fstate, xout, tout, out_extra] = walk(xi,1);
vector = boolean([0,0,1,1,0,0,1,1]);
maxeig = max(abs(eigenmap(fstate,1,1,vector)));

temp_exp_results.center.ratio = ratio_start;
temp_exp_results.center.Parameters = flowdata.Parameters.(params_name);
temp_exp_results.center.State.extra = flowdata.State;
temp_exp_results.center.State.xi = fstate.*vector;
temp_exp_results.center.maxeig = maxeig;
temp_exp_results.center.speed = out_extra.steps{end}.speed;
temp_exp_results.center.xout = xout;
temp_exp_results.center.tout = tout;
temp_exp_results.center.out_extra = out_extra;
if isfield(flowdata.Parameters, 'KPBC')
     temp_exp_results.center.Eref = flowdata.Parameters.KPBC.Eref.SSupp;
end
%Go up and down from start
dirnames = {'up','down'};
for index = 1:2
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
    step_size = step_size_start;
    ratio = ratio_start;
    %Loop over system parameters
    while abs(step_size) > step_tol && abs(step_size) < max_step

        flowdata.Flags.terminate = 0;
        if stable && done %take a bigger step
            step_size = step_size*c;
            if strcmp(direction,'down')               
               ratio = ratio - step_size;
            elseif strcmp(direction,'up')
               ratio = ratio + step_size;
            end
        else %undo previous step and take a smaller one
           prev_step = step_size;
           step_size = step_size/c;
           if strcmp(direction,'down')
               ratio = ratio + prev_step - step_size;
           elseif strcmp(direction,'up')
               ratio = ratio - prev_step + step_size;
           end
        end
        
        run(param_update_script)
        
        %Get first biped step
        [fstate, xout, tout, out_extra] = walk(guess,1);
        e_last = inf;
        e = 0;
        done = false;

        if ratio > 0
            fprintf( strcat("\n \n Ratio: " , num2str(ratio), " Step size: ", num2str(step_size), "\n") );
            %Check every 'step_check_num' steps for convergence or failure
            w_cyc_count = 0;
        else
            w_cyc_count = inf;
            stable = false;
        end
        
        
        while flowdata.Flags.terminate == 0 && (last_speed > min_speed) && ~done && (e <= e_last) && w_cyc_count < w_cyc_max && ~any(isnan(fstate))
            fprintf("walking...")
            flowdata.Flags.silent = false;
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
            flowdata.Flags.silent = true;
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
            temp_exp_results.(direction).ratio{count} = ratio;
            temp_exp_results.(direction).Parameters{count} = flowdata.Parameters.(params_name);
            temp_exp_results.(direction).State.extra{count} = {flowdata.State};
            temp_exp_results.(direction).State.xi{count} = fstate.*vector;
            temp_exp_results.(direction).maxeig{count} = maxeig;
            temp_exp_results.(direction).speed{count} = out_extra.steps{end}.speed;
            temp_exp_results.(direction).xout{count} = xout;
            temp_exp_results.(direction).tout{count} = tout;
            temp_exp_results.(direction).out_extra{count} = out_extra;
            if isfield(flowdata.Parameters, 'KPBC')
                 temp_exp_results.(direction).Eref{count} = flowdata.Parameters.KPBC.Eref.SSupp;
            end
            
        else %unstable
           fprintf(strcat("Unstable", "\n"))
        end
    end
end

%format and save results
fnames_d = fieldnames(temp_exp_results.down);
fnames_c = fieldnames(temp_exp_results.center);
fnames_u = fieldnames(temp_exp_results.up);
if all(strcmp(fnames_d,fnames_c)) && all(strcmp(fnames_d,fnames_u))
    fnames = fnames_d;
    for k = 1:length(fnames)
        search_results.(results_name).(fnames{k}) = ...
            [flip(temp_exp_results.down.(fnames{k})),temp_exp_results.center.(fnames{k}), temp_exp_results.up.(fnames{k})];
    end
end
if dosave
    save Experiments\EnergyShapeAndTrack_Compass\Data\search_results search_results
end
toc