function c = mycost_fminsearch(v)
%MYCOST_FMINCON Cost function for optimization procedure to find a stable limit
%cycle for a locked knee biped. It is minimized when the biped reaches the same joint state over 1
%step. 
%   Takes the joint pos and vel as inputs, starts x,y pos and vel at 0. 
global flowdata
    
    x = zeros(1,12);
    x(3:6) = v(1:4);       %stance ankle
    x(3+6:6+6) = v(5:8);

    flowdata.State.c_phase = 'SSupp';
    flowdata.State.c_configs = {};
    flowdata.State.Eref = 0;
    flowdata.odeoptions.Events = flowdata.Phases.SSupp.eventf;
    flowdata.resetFlags();

    [fstate1, ~, ~, out_extra] = walk(x,1);
    %[fstate2, ~, ~, ~] = walk(fstate1,1);

    e1 = x - fstate1;
    qe1 = e1(3:6); %Ignore first to entries corresponding to x,y pos in ground frame. 
    qe_dot1 = e1(7:12);
    
    %e2 = x - fstate2;
    %qe2 = e2(3:6); %Ignore first to entries corresponding to x,y pos in ground frame. 
    %qe_dot2 = e2(7:12);
    
    % if the simulation terminates early or ouputs garbage, penalize a lot
    if flowdata.Flags.terminate || any(isnan(e1)) || any(isinf(e1)) 
        c = 1e6;
    else
        c = norm(qe1) + norm(qe_dot1)*0.1;% + norm(qe2)*0.05 + norm(qe_dot2)*0.005; %scaled the velocities down
    end
    
end

