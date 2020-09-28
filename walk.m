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

    flowdata.odeoptions.Events = @guard;
    if ~flowdata.Flags.silent
        myprint('New Walking Simulation \n \t');
    end

    if all(size(xi) ~= [1,flowdata.Parameters.dim])
        fprintf('Input vector must have %i rows and %i columns.\n', size(xi)*[1 0]', size(xi)*[0 1]');
        fstate = []; xout = []; 
        return
    end
  
    %output variable initializions
    xout = [];
    tout = [];
    x_postimpacts = zeros(steptotal,flowdata.Parameters.dim);% all impact-event states
    x_preimpacts = zeros(steptotal,flowdata.Parameters.dim); % all pre-impact-event states
    t_impacts = zeros(steptotal,1);       % all impact-event times
    t_end_prev = 0;
    ti = 0;
    stepOutputs = {};
    
    %run the simulation for n steps
    stepnum = 1;
    flowdata.Flags.terminate = false;
    while stepnum<=steptotal && ~flowdata.Flags.terminate
        %Display step number      
        myprint(strcat('Step ' ,num2str(stepnum), ' \t'));
        
        %Update potential energy datum to y position at start of step.
        flowdata.Flags.step_done = false;
        if flowdata.Flags.rigid
            flowdata.State.PE_datum = xi(2);
        end
        
        %Entry into simulation 
        ti = t_end_prev;
        [x_end, t_end, xstep, tstep, step_out] = step(ti,xi);
              
        %Check if step completed
        if isempty(t_end)
            warning(strcat('Biped did not complete step number ',num2str(stepnum), ' ,simulation ending early. '))
            t_end = nan;
            x_end = NaN(flowdata.Parameters.dim,1);
            flowdata.Flags.terminate = true;
        end

        %Update outputs
        t_end = t_end(end);
        t_impacts(stepnum) = t_end; 
        tout = [tout ; tstep];
        xout = [xout ; xstep];      
        x_postimpacts(stepnum,:) = x_end;
        x_preimpacts(stepnum,:) = xstep(end,:);                                                                             
        stepOutputs{stepnum}=step_out; %#ok<*AGROW>

        %Updates for next loop
        xi = x_end;  
        stepnum = stepnum+1;
        t_end_prev = t_end;
    end
    
    %Format Outputs
    fstate = x_end;     
    out_extra.steps =  stepOutputs;
    out_extra.t_impacts = t_impacts;            
    out_extra.x_preimpacts = x_preimpacts;      %Gives the pre-impact state vector BEFORE end-of-step
    out_extra.x_postimpacts = x_postimpacts;    %Gives the pre-impact state vector AFTER end-of-step
    for i = 1:length(flowdata.WalkOutputFuncs)
        f = flowdata.WalkOutputFuncs{i};
        out_extra.(func2str(f)) =  f(tout,xout,stepOutputs);
    end
    myprint('\n');
end
