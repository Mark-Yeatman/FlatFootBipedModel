function [value, isterminal, direction] =  guard_SpringApexSSupp(t, x)
%guard_SpringApexSSupp Summary of this function goes here
%   Detailed explanation goes here
    global flowdata
    Ldot = Spring_Velocity_func(x,flowdata.State.pf1);
    value = Ldot;
    isterminal =  x(1)>flowdata.State.pf1(1) && strcmp('SSupp',flowdata.State.c_phase); %only release when mass moving up
    direction = -1;
end

