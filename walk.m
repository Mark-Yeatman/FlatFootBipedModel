function [fstate, xout, tout, out_extra] = walk(xi, steptotal)
% WALK2   Walk the robot for "steptotal" number of steps.
% 
% INPUT:
% + xi = the input state vector, configuration q and their velocites qdot. Passed to
%       step. q = [x, y, heel, ankle, stance knee, hip, swing knee,swing ankle].
% + steptotal = specify the number of steps the walker should take.
% 
% 
% OUTPUT:
% Note: time is the first column in all of these outputs. 
% + fstate: the state after impact on the last step. 
% + xout: all the states beginning from time = 0 to the time 
%           of the last point of contact with the slope.
% + tout: vector of times that match with xout
% + out_extra:  struct of extra outputs,
%     out_extra.t_impacts       %a cell array of n steps. Each cell has a 3x1 array that gives the time when the biped siwtches from: heel->flat,  flat->toe, toe->swing heel
%     out_extra.istate_minus    %an array of n (steps) x 16 doubles. It gives the pre-impact state vector BEFORE heel strike
%     out_extra.istate_plus     %an array of n (steps) x 16 doubles. It gives the post-impact state vector AFTER heel strike

global flowdata 
    
    %set guard as ode event function 
    flowdata.odeoptions.Events = @guard;

    if ~flowdata.Flags.silent
        disp('New Walking Simulation');
    end

    if size(xi) ~= [1,flowdata.Parameters.dim] 
        fprintf('walk error: Input state vector must have %i rows and %i columns.\n', size(xi)*[1 0]', size(xi)*[0 1]');
        fstate = []; xout = []; 
        return
    end
  
    %output variable initializions
    x = [];
    t = [];
    x_postimpacts = zeros(steptotal,flowdata.Parameters.dim);% all impact-event states
    x_preimpacts = zeros(steptotal,flowdata.Parameters.dim); % all pre-impact-event states
    t_impacts = zeros(steptotal,1);       % all impact-event times
    t_end_prev = 0;
    stepOutputs = {};
    
    %run the simulation for n steps
    stepnum = 1;
    flowdata.Flags.terminate = false;
    while stepnum<=steptotal && ~flowdata.Flags.terminate
        %Display step number      
        myprint(strcat('Step ' ,num2str(stepnum), ' \t'));
                
        %Entry into simulation 
        flowdata.Flags.step_done = false;
        if flowdata.Flags.rigid
            flowdata.State.PE_datum = xi(2);
        end
        [x_end, t_end, xstep, tstep, s_output] = step(xi);
        
       
        %Check if step completed
        if isempty(t_end)
            warning(strcat('Biped did not complete step number ',num2str(stepnum), ' ,simulation ending early. '))
            t_end = nan;
            x_end = NaN(flowdata.Parameters.dim,1);
            flowdata.Flags.terminate = true;
        else

        end

        %Update output arrays
        t_end = t_end(end);
        t_impacts(stepnum) = t_end + t_end_prev; 
        t = [t ; tstep + t_end_prev];
        x = [x ; xstep];      
        x_postimpacts(stepnum,:) = x_end;
        x_preimpacts(stepnum,:) = xstep(end,:);                      % assign the last row of xbefore to the "step" row of the x_preimpacts
        xi = x_end;                                                  % Re-assign initial conditions

        stepOutputs{stepnum}={s_output,t_end_prev}; %#ok<*AGROW>

        %Updates for next loop
        stepnum = stepnum+1;
        t_end_prev = t_end + t_end_prev;
    end
    
    %Format Outputs
    fstate = x_end;
    xout = x;
    tout = t;
       
    out_extra = WalkOutputs(t,x,stepOutputs);
    out_extra.t_impacts = t_impacts;        %a cell array of n steps. Each cell has a 3x1 array that gives the time when the biped siwtches from: heel->flat,  flat->toe, toe->swing heel
    out_extra.istate_minus = x_preimpacts;  %an array of n (steps) x 16 doubles. It gives the pre-impact state vector BEFORE heel strike
    out_extra.istate_plus = x_postimpacts;  %an array of n (steps) x 16 doubles. It gives the post-impact state vector AFTER heel strike
    
    myprint('\n');
end
