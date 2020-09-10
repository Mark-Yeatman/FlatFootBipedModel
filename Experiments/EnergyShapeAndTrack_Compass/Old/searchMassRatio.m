%This experiment uses feedback control to change the mass ratio Mh/Ms in
%the continuous dynamics, while using the true physical parameters for the
%impact dynamics. 

%The true parameters come from:
%"Limit cycles in a passive compass gait biped and passivity-mimicking control laws"
%The ratio is swept up and down from here in a grid
clear flowdata ratio_results_up ratio_results_down physical_mass_ratio_sweep_results
path(pathdef)
addpath(genpath('Experiments\EnergyShapeAndTrack_Compass\'))
addpath('Analysis\')
addpath('UtilityFunctions\')
addpath(genpath('Models\2LinkCompassGait\'))

%The initial ratio is Mh = 10, Ms = 5, Mh/Ms = 2
%Initialized on stable limit cycle
initializeCompassGaitLimitCycle
flowdata.Flags.silent = true;
[fstate, xout, tout, out_extra] = walk(xi,1);

%Custom Search variables
last_speed = inf;
stable = true;
vector = boolean([0,0,1,1,0,0,1,1]);
count = 0;
ratio_results_up = {};
ratio = 2;
step_size = 0.5;

maxeig = max(abs(eigenmap(fstate,1,1,vector)));

ratio_results_center.ratio = ratio;
ratio_results_center.Parameters = flowdata.Parameters.Biped;
ratio_results_center.State = flowdata.State;
ratio_results_center.maxeig = maxeig;
ratio_results_center.fstate = fstate.*vector;
ratio_results_center.speed = out_extra.steps{end}.speed;

%fminsearch options
% fun = @cost_fminsearch;
% flowdata.Parameters.Opt = struct();
% flowdata.Parameters.Opt.weight = 0.1;
% options = optimset(@fminsearch);
% options.TolFun = 1e-7;
% options.TolX = 1e-7;
guess = fstate;

%search for upper limit using a sort of golden ratio search
c = 1.61803398875; %the golden ratio
while abs(step_size) > 0.001 && abs(step_size) < 100
    ratio = ratio + step_size;
    fprintf( strcat("\n \n Ratio: " , num2str(ratio), " Step size: ", num2str(step_size), "\n") );
    flowdata.Parameters.Biped.Mh = 10 * ratio * 5/10;
    flowdata.Parameters.Biped.Ms = 5;
    flowdata.Parameters.Biped.a = 0.5;
    flowdata.Parameters.Biped.b = 0.5;
    flowdata.Parameters.Biped.asvector = [flowdata.Parameters.Biped.Mh, 5, 0.5, 0.5]; 
    
%     %use optimization to find equilibrium point
%     x0 = guess([3:4,7:8]);
%     options.PlotFcn = 'optimplotfval';
%     flowdata.Flags.silent = true;
%     
%     tic;
%     [zout,objval,exitflag] = fminsearch(fun,x0,options);
%     toc;

    %use simulation to find equilibrium point
    flowdata.Flags.silent = true;
    [fstate, xout, tout, out_extra] = walk(guess,1);
    e_last = norm(fstate(vector) - guess(vector));
    e = e_last;
    done = false;
    while flowdata.Flags.terminate == 0 && (last_speed > 0.1) && ~done && (e <= e_last)
        fprintf("walking...")
        e_last = e;
        [fstate, xout, tout, out_extra] = walk(fstate,25);
        e = norm(fstate(vector) - out_extra.istate_plus(end-1,vector) );
        done = e < 1e-6;
        last_speed = out_extra.steps{end}.speed;        
    end
    fprintf("\n")
    
    %test stability
    flowdata.Flags.silent = false;
    [fstate, xout, tout, out_extra] = walk(fstate,1);
    flowdata.Flags.silent = true;
    fprintf("Checking stability...")
    maxeig = max(abs(eigenmap(fstate,1,1,vector)));
    stable = maxeig < 1; 
 
    if stable && done
       fprintf(strcat("Stable", "\n"))
       guess = fstate;
       guess(~vector) = 0;
       step_size = abs(step_size) * c;
       count = count + 1;
       ratio_results_up.ratio{count} = ratio;
       ratio_results_up.Parameters{count} = flowdata.Parameters.Biped;
       ratio_results_up.State{count} = flowdata.State;
       ratio_results_up.maxeig{count} = maxeig;
       ratio_results_up.fstate{count} = fstate.*vector;
       ratio_results_up.speed{count} = out_extra.steps{end}.speed;
    else
       %reuse previous starting state guess
       fprintf(strcat("Unstable", "\n"))
       step_size = -abs(step_size) / c;
    end
    
end

%search for lower limit 
initializeCompassGaitLimitCycle

flowdata.Flags.silent = true;
[fstate, xout, tout, out_extra] = walk(xi,1);
guess = fstate;

step_size = -0.1;
ratio = 2 + step_size;
ratio_results_down = {};
count = 0;
while abs(step_size) > 0.001 && ratio > 1e-5

    fprintf( strcat("\n \n Ratio: " , num2str(ratio), " Step size: ", num2str(step_size), "\n") );
    flowdata.Parameters.Biped.Mh = 10 * ratio * 5/10;
    flowdata.Parameters.Biped.Ms = 5;
    flowdata.Parameters.Biped.a = 0.5;
    flowdata.Parameters.Biped.b = 0.5;
    flowdata.Parameters.Biped.asvector = [flowdata.Parameters.Biped.Mh, 5, 0.5, 0.5]; 
    
%     %use optimization to find equilibrium point
%     x0 = guess([3:4,7:8]);
%     options.PlotFcn = 'optimplotfval';
%     flowdata.Flags.silent = true;
%     
%     tic;
%     [zout,objval,exitflag] = fminsearch(fun,x0,options);
%     toc;

    %use simulation to find equilibrium point
    flowdata.Flags.silent = true;
    [fstate, xout, tout, out_extra] = walk(guess,1);
    e_last = inf;
    e = 1;
    done = false;
    last_speed = inf;
    subcount = 1;
    while flowdata.Flags.terminate == 0 && (last_speed > 0.1) && ~done && ( e < 1e-8 ||(e <= e_last)) && subcount < 10
        fprintf("walking...")
        e_last = e;
        [temp, xout, tout, out_extra] = walk(fstate,25);
        e = norm(temp(vector) - out_extra.istate_plus(end-1,vector) );
        done = e < 1e-6;
        if (e < 1e-8 ||(e <= e_last))
            fstate = temp;
        else

        end
        last_speed = out_extra.steps{end}.speed;
        subcount = subcount + 1;
    end
    fprintf("\n")
   
    %test stability
    flowdata.Flags.silent = false;
    [fstate, xout, tout, out_extra] = walk(fstate,1);
    flowdata.Flags.silent = true;
    fprintf("Checking stability...")
    maxeig = max(abs(eigenmap(fstate,1,1,vector)));
    stable = maxeig < 1; 
        
    if stable && done
       fprintf(strcat("Stable", "\n"))
       guess = fstate;
       guess(~vector) = 0;
       if ratio + step_size>0
            step_size = -abs(step_size);
       else
            step_size = -abs(step_size) / c;
       end
       count = count + 1;
       ratio_results_down.ratio{count} = ratio;
       ratio_results_down.Parameters{count} = flowdata.Parameters.Biped;
       ratio_results_down.State{count} = flowdata.State;
       ratio_results_down.maxeig{count} = maxeig;
       ratio_results_down.fstate{count} = fstate.*vector;
       ratio_results_down.speed{count} = out_extra.steps{end}.speed;
    else
       %reuse previous starting state guess
       fprintf(strcat("Unstable", "\n"))
       step_size = abs(step_size) / c;
    end
    ratio = ratio + step_size;
end
fnames = fieldnames(ratio_results_down);
for k = 1:length(fnames)
    physical_mass_ratio_sweep_results.(fnames{k}) = ...
        [flip(ratio_results_down.(fnames{k})),ratio_results_center.(fnames{k}), ratio_results_up.(fnames{k})];
end
save Experiments\EnergyShapeAndTrack_Compass\Data\MassRatioSearch physical_mass_ratio_sweep_results -append