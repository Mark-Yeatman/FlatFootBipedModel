function c = cost_fminsearch(v)
%COST_FMINCON Cost function for optimization procedure to find a stable limit
%cycle for a compass gait biped.It is minimized when the biped reaches 
%the same joint state over 1 step. 
%   Takes the joint state subspace of the biped (qa,qh,qadot,qhdot) as input. 
%   The cost function sets x,y states as 0.  
%   There is a weighting between the joint pos vs joint vel in the cost.
global flowdata
    
    w = flowdata.Parameters.Opt.weight;
    x = zeros(1,8);
    if length(v) ~= 4
        error('Input vector is wrong dimension')
    end
    x(3:4) = v(1:2);       
    x(7:8) = v(3:4);
    
    flowdata.State.c_phase = 'SSupp';
    flowdata.State.c_configs = {};
    flowdata.State.PE_datum = 0;
    [fstate, xout, tout, out_extra] = walk(x,1); %#ok<*ASGLU>

    e1 = x - fstate;
    qe1 = e1(3:4); %Ignore entries corresponding to x,y pos in ground frame. 
    qe_dot1 = e1(7:8); %Ignore entries corresponding to x,y vel in ground frame. 
        
    % If the simulation terminates early or ouputs garbage, heavily penalize
    if flowdata.Flags.terminate || any(isnan(e1)) || any(isinf(e1)) 
        c = 1e6;
    else
        c = norm(qe1) + norm(qe_dot1)*w;
    end
    
end

