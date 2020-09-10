function [x_end, t_end, xstep, tstep, out] = step(xin)
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
    tcontact_start = 0;
    xcontact_plus =  xin;
    xstep=[];
    tstep=[];
    phase_outputs={};
    
    iter = 0;
    max_iter = 10;

    while ~flowdata.Flags.terminate && ~flowdata.Flags.step_done && iter<max_iter
        iter = iter+1;        
        [tphase,xphase,tcontact_end,xcontact_minus,ie,phase_out] = phase(tcontact_start(end),xcontact_plus);
        
        %Check if impact event even happened
        if isempty(ie)  
            imp_name = 'None';
            flowdata.Flags.terminate = true;
            tcontact_end = nan;
            xcontact_plus = nan*xin;
        else
            imp_name = flowdata.Impacts{ie(end)}.name;
            xcontact_plus = impact(xcontact_minus,ie);  %post impact state            
        end  
              
        xstep = [xstep;xphase];                              %State
        tstep = [tstep;tphase];                              %#ok<*AGROW> %Time      
        phase_out.xcontact_plus = xcontact_plus;
        phase_outputs{iter} = {phase_out,...
                               tcontact_start,...
                               tcontact_end(end),...
                               imp_name};       
        tcontact_start = tcontact_end(end);
    end
    
    x_end = xcontact_plus;
    t_end = tcontact_end(end); 
    out = StepOutputs(tstep,xstep,phase_outputs,xin);

    if flowdata.Flags.step_done 
        myprint('Step Done. \n \t ');        
        if isfield(out,'Eref')
            myprint(strcat('Length: ', num2str(out.steplength),' Speed: ',num2str(out.speed),' Eref: ', num2str(out.Eref(1)), '.\n'  ));
        elseif isfield(out,'steplength')
            myprint(strcat('Length: ', num2str(out.steplength),' Speed: ',num2str(out.speed), '.\n'  ));
        end
    elseif isempty(ie)  
        myprint('\nBiped did not impact the ground. \n'); 
    end

end
