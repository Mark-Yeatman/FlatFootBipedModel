function [x_end, t_end, xstep, tstep, out] = step(tin,xin)
% STEP2   Simulate 1 step and calculate state after impact.
%
% [xafter, tafter, xbefore, tbefore] = step(xin);
%
% INPUTS:
% + xin = input state vector, angles and their rates of change.

% OUTPUTS:
% + xafter = state after impact. 
% + tafter = time at impact. 
% + xbefore = vector of the states at each integration time, up to impact.
% + tbefore = vector of times for each state

global flowdata
    %loop initializations
    tcontact_start = tin;
    xcontact_plus =  xin;
    xstep=[];
    tstep=[];
    phase_out_array={};
    
    iter = 0;
    max_iter = 10;

    while ~flowdata.Flags.terminate && ~flowdata.Flags.step_done && iter<max_iter
        iter = iter+1;        
        [tphase,xphase,tcontact_end,xcontact_minus,ie,phase_out] = phase(tcontact_start(end),xcontact_plus);
        
        %Check if impact event even happened
        if isempty(ie)  
            flowdata.Flags.terminate = true;
            tcontact_end = nan;
            xcontact_plus = nan*xin;
        else
            xcontact_plus = impact(xcontact_minus,ie);  %post impact state            
        end  
              
        xstep = [xstep;xphase];                              %State
        tstep = [tstep;tphase];                              %#ok<*AGROW> %Time           
        tcontact_start = tcontact_end(end);
        phase_out_array{end+1} = phase_out;
    end
    
    x_end = xcontact_plus;
    t_end = tcontact_end(end); 
    out.phases = phase_out_array;
    for i = 1:length(flowdata.StepOutputFuncs)
        f = flowdata.StepOutputFuncs{i};
        out.(func2str(f)) =  f(tstep,xstep,phase_out_array);
    end
    
    if flowdata.Flags.step_done 
        myprint('Step Done. \n \t');        
    elseif isempty(ie)  
        myprint('\n Simulation hit end of tspan. \n'); 
    end

end
