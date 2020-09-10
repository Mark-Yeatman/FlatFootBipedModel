function [value, isterminal, direction] = guardFlight(t, x)
global flowdata
    if flowdata.Flags.ignore
        CV = [];
    else
        CV = constraintValidation(t,x);
    end
    %value, isterminal, direction
    LeadStrike   = [1, 0, 0];
    TrailRelease = [1, 0, 0];
    FullRelease  = [1, 0, 0];
    Landing = [x(2)-flowdata.Parameters.SLIP.L0*sin(flowdata.State.alpha), x(4)<0, -1];
    %Apex  = [x(4),0,0];
    %guard = [LeadStrike',  TrailRelease', FullRelease', Landing', Apex', CV'];
    guard = [LeadStrike',  TrailRelease', FullRelease', Landing', CV'];
    
    value=       guard(1,:)';
    isterminal = guard(2,:)';
    direction =  guard(3,:)';
end