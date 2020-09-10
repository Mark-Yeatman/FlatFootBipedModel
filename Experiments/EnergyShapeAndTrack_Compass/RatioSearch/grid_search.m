%Script for general workflow related to searching for new limit cycles by
%slowly changing system parameters from an initial parameter set and stable cycle

%search for upper limit using a grid search
tic

path(pathdef)
addpath('Experiments\EnergyShapeAndTrack_Compass\')
addpath('Experiments\EnergyShapeAndTrack_Compass\Data')
addpath('Experiments\EnergyShapeAndTrack_Compass\RatioSearch\')
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

dosave = true;
load("Experiments\EnergyShapeAndTrack_Compass\Data\grid_results")

%Custom setup variables

%% search physical length ratio config
% results_name = 'physical_length_ratio';
% param_update_script = 'searchPhysicalLengthRatio';
% 
% grid_res_up = 0.05;
% grid_res_down = 0.05;
% ratio = 1;
% ratio_max = 2;
% ratio_min = 0.5;
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search shape length ratio config
% results_name = 'shape_length_ratio';
% param_update_script = 'searchShapeLengthRatio';
% 
% grid_res_up = 0.05;
% grid_res_down = 0.05;
% ratio = 1;
% ratio_max = 2;
% ratio_min = 0.5;
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search shape length ratio + epbc config + adaptive ball
% results_name = 'shape_length_ratio_epbc_ball';
% param_update_script = 'searchShapeLengthRatioEPBC';
% 
% grid_res_up = 0.05;
% grid_res_down = 0.05;
% ratio = 1;
% ratio_max = max([grid_results.physical_length_ratio.ratio{:}]);
% ratio_min = min([grid_results.physical_length_ratio.ratio{:}]);
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search shape length ratio + epbc + adaptive speed track config
results_name = 'shape_length_ratio_epbc_adaptive_speed';
param_update_script = 'searchShapeLengthRatioEPBCAdaptive';

grid_res_up = 0.05;
grid_res_down = 0.05;
ratio = 1;
ratio_max = max([grid_results.physical_length_ratio.ratio{:}]);
ratio_min = min([grid_results.physical_length_ratio.ratio{:}]);

grid{1} = ratio;
grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));

step_check_num = 20;
walk_e_tol = 1e-6;
w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search physical mass ratio config
% results_name = 'physical_mass_ratio';
% param_update_script = 'searchPhysicalMassRatio';
% 
% grid_res_up = 0.1;
% grid_res_down = 0.1;
% ratio = 2;
% ratio_max = 3;
% ratio_min = 1;
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search shape mass ratio config
% results_name = 'shape_mass_ratio';
% param_update_script = 'searchShapeMassRatio';
% 
% grid_res_up = 0.1;
% grid_res_down = 0.1;
% ratio = 2;
% ratio_max = 3;
% ratio_min = 1;
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search shape mass ratio + epbc config + adaptive ball
% results_name = 'shape_mass_ratio_epbc_ball';
% param_update_script = 'searchShapeMassRatioEPBC';
% 
% grid_res_up = 0.1;
% grid_res_down = 0.1;
% ratio = 2;
% ratio_max = max([grid_results.physical_mass_ratio.ratio{:}]);
% ratio_min = min([grid_results.physical_mass_ratio.ratio{:}]);
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search shape mass ratio + epbc + adaptive speed track config
% results_name = 'shape_mass_ratio_epbc_adaptive_speed';
% param_update_script = 'searchShapeMassRatioEPBCAdaptive';
% 
% grid_res_up = 0.1;
% grid_res_down = 0.1;
% ratio = 2;
% ratio_max = max([grid_results.physical_mass_ratio.ratio{:}]);
% ratio_min = min([grid_results.physical_mass_ratio.ratio{:}]);
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search physical gravity
% results_name = 'physical_gravity';
% param_update_script = 'searchPhysicalGravity';
% 
% grid_res_up = 0.5;
% grid_res_down = 0.5;
% ratio = 9.81;
% ratio_max = 9.81 + 0.5;
% ratio_min = 9.81 - 0.5;
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search shape gravity
% results_name = 'shape_gravity';
% param_update_script = 'searchShapeGravity';
% 
% grid_res_up = 0.5;
% grid_res_down = 0.5;
% ratio = 9.81;
% ratio_max = 9.81 + 0.5;
% ratio_min = 9.81 - 0.5;
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 20;
% walk_e_tol = 1e-6;
% w_cyc_max = 3; %-> max number of steps = step_check_num * w_cyc_max 

%% search EPBC + adaptive only config
% results_name = 'shape_epbc';
% param_update_script = 'searchEPBC';
% 
% grid_res_up = 0.05;
% grid_res_down = 0.05;
% ratio = 1;
% ratio_max = max([grid_results.physical_length_ratio.ratio{:}]);
% ratio_min = min([grid_results.physical_length_ratio.ratio{:}]);
% 
% grid{1} = ratio;
% grid{2} = (ratio + grid_res_up):grid_res_up:ratio_max;
% grid{3} = flip(ratio_min:grid_res_down:(ratio-grid_res_down));
% 
% step_check_num = 25;
% walk_e_tol = 1e-6;
% w_cyc_max = 5; %-> max number of steps = step_check_num * w_cyc_max

%% Start Search 
clear('flowdata','temp_exp_results');

global flowdata
flowdata = flowData;
flowdata.E_func = @TotalE_func;

%ODE equation handle and tolerenaces
flowdata.eqnhandle = @dynamics;
flowdata.odeoptions = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

%Flags
flowdata.Flags.silent = false;
flowdata.Flags.ignore = true;
flowdata.Flags.do_validation = false;

%Simulation parameters
flowdata.Parameters.Environment.slope = -deg2rad(3.7);   %ground slope
g = 9.81;
flowdata.Parameters.Environment.g = g;
flowdata.Parameters.dim = 8;        %state variable dimension

%Initial stuff
vector = boolean([0,0,1,1,0,0,1,1]);
load('xi.mat')

%Go up and down from start
names = {'center','up','down'};
for index = 1:length(names)
    %Workflow variables
    stable = true;
    done = true;
    count = 1;
    direction = names{index};
    temp_exp_results.(direction) = struct();
    
    %Discrete Mappings and Constraints
    flowdata.setPhases({'SSupp'})
    flowdata.setConfigs({})
    impactlist =  {'FootStrike'};
    e1 = struct('name','FootStrike','nextphase','SSupp','nextconfig','');
    e2 = struct('name','FallForward','nextphase','Failure','nextconfig','');
    e3 = struct('name','FallBackward','nextphase','Failure','nextconfig','');
    flowdata.Phases.SSupp.events = {e1,e2,e3};
    flowdata.End_Step.event_name = 'FootStrike';

    %Set initial phase, contact conditions, and state
    flowdata.State.c_phase = 'SSupp';
    flowdata.State.c_configs = {};
    flowdata.setImpacts();
    
    fstate = xi;
    
    %Loop over system parameters
    while count <= length(grid{index})                  
        ratio = grid{index}(count);
        
        if ratio > 0
            fprintf( strcat("Ratio: " , num2str(ratio),'\n') );
%             if isfield(flowdata.Parameters,'Eref_Update')
%                 fprintf(strcat("v ref: ", num2str(flowdata.Parameters.Eref_Update.vref),' m/s \n'))
%             end
            w_cyc_count = 0;
        else
            w_cyc_count = inf;
            stable = false;
        end
        
        flowdata.Flags.terminate = 0;
        e_last = inf;
        e = 0;
        done = false;
        run(param_update_script)
        %Check every 'step_check_num' steps for convergence or failure
        while flowdata.Flags.terminate == 0  && ~done && (e <= e_last) && w_cyc_count < w_cyc_max && ~any(isnan(fstate))
            fprintf("walking...")
            flowdata.Flags.silent = false;
            [fstate, xout, tout, out_extra] = walk(fstate, step_check_num);
            e = norm(fstate(vector) - out_extra.istate_plus(end-1,vector) );
            done = e < walk_e_tol && ~any(isnan(fstate)); 
            w_cyc_count = w_cyc_count+1;
        end
        %fprintf("\n")

        %test stability using linearized poincare section eigenvalues
        if done
            flowdata.Flags.silent = false;
            [fstate, xout, tout, out_extra] = walk(fstate,1);
            if isfield(flowdata.Parameters,'Eref_Update')
                flowdata.Parameters.KPBC.Eref.SSupp = flowdata.State.Eref;
            end
            fprintf("Checking stability...")
            maxeig = max(abs(eigenmap(fstate,1,1,vector)));
            stable = maxeig < 1;
        end

        %Save results
        if stable && done
            fprintf(strcat("Stable", "\n"))

            %reset value of cyclic variables 
            fstate = fstate.*vector; 
            flowdata.State.PE_datum = 0;

            temp_exp_results.(direction).ratio{count} = ratio;
            temp_exp_results.(direction).Parameters{count} = flowdata.Parameters;
            temp_exp_results.(direction).State{count}.extra = flowdata.State;
            temp_exp_results.(direction).State{count}.xi = fstate.*vector;
            temp_exp_results.(direction).maxeig{count} = maxeig;
            temp_exp_results.(direction).speed{count} = out_extra.steps{end}.speed;
            temp_exp_results.(direction).steplength{count} = out_extra.steps{end}.steplength;
            temp_exp_results.(direction).xout{count} = xout;
            temp_exp_results.(direction).tout{count} = tout;
            temp_exp_results.(direction).out_extra{count} = out_extra;
        else %unstable
           fprintf(strcat("Unstable", "\n"))
           break
        end
        count = count + 1;
    end
end

%% format and save results
fnames_d = fieldnames(temp_exp_results.down);
fnames_c = fieldnames(temp_exp_results.center);
fnames_u = fieldnames(temp_exp_results.up);
if isfield(grid_results , results_name)
    grid_results = rmfield( grid_results , results_name);
end
if ~isempty(fnames_c)  
    fnames = fnames_c;      
    for k = 1:length(fnames_c)
        grid_results.(results_name).(fnames{k}) = temp_exp_results.center.(fnames{k});
    end 
end
if ~isempty(fnames_u)  
    fnames = fnames_u;      
    for k = 1:length(fnames)
        grid_results.(results_name).(fnames{k}) = cat(2,grid_results.(results_name).(fnames{k}),temp_exp_results.up.(fnames{k}));          
    end 
end
if ~isempty(fnames_d)  
    fnames = fnames_d;      
    for k = 1:length(fnames)
        grid_results.(results_name).(fnames{k}) = cat(2,flip(temp_exp_results.down.(fnames{k})),grid_results.(results_name).(fnames{k}));          
    end 
end   

if dosave
    save Experiments\EnergyShapeAndTrack_Compass\Data\grid_results grid_results
end
toc
fprintf(strcat(param_update_script, " is done. \n", results_name, " has been updated. \n"));

load handel
yl = int32(length(y)/4);
sound(y(1:yl),Fs)