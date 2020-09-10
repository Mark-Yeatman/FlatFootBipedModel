function [value, isterminal, direction] = guard_KneeUnlockSt(t, x)
%GUARD_KNEELOCKST Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    [~,F] = getGroundReactionForces(t,x);
    [A,~] = flowdata.getConstraintMtxs(x,cell2mat(flowdata.Parameters.Biped.values));
    Tau = A'*F;
    value = Tau(4);
    isterminal = 1;
    direction = 1;
end


