function [value, isterminal, direction] = guardDSupp(t, x)
global flowdata
    
    [GRF,F] = getGroundReactionForces(t,x);
    [A,~] = flowdata.getConstraintMtxs(x);
    if isnan(GRF(4))
       GRF(4) = 1;
    end
    if flowdata.Flags.do_validation
        CV = constraintValidation(0,x);
    else
        value=[];
        isterminal=[];
        direction=[];
        CV=[];
    end
    a = A'*F(1:min(size(A)));
    %value, isterminal, direction
    dontcheck = [1, 0, 0];
    FootStrike  = dontcheck;
    %COPatLead = [COP_dist,1,-1];
    TrailLift = [GRF(4),1,-1];
    SwKneeLockout = [x(6), ~any(contains(flowdata.State.c_configs,'KLockSw')),   0];
    %StKneeLockout = [x(4), ~any(contains(flowdata.State.c_configs,'KLockSt')),   0];
    StKneeLockout = dontcheck;
    SwKneeUnlock = [a(6), abs(x(6))<1e-5,    1];
    %StKneeUnlock = [a(4),  abs(x(4))<1e-5,   1];
    StKneeUnlock = dontcheck;
    %guard =[FootStrike',  TrailLift' , SwKneeLockout' , StKneeLockout' , SwKneeUnlock' , StKneeUnlock'];
    guard =[FootStrike',  TrailLift', CV];
    value =      guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);

    temp = find(abs(value)<1e-6);
    if nnz(abs(value)<1e-6) > 1
        value(temp(2:end))=1;
    end
end