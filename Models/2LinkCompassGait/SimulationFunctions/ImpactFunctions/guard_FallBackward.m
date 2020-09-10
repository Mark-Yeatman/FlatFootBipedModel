function [value, isterminal, direction] = guard_FallBackward(t, x)  
    global flowdata
    %value, isterminal, direction
    %FallForward  = [x(3) - flowdata.Parameters.Environment.slope - pi/2, 1, 0];
    FallBackward  = [x(3) - flowdata.Parameters.Environment.slope - pi/2, 1, 0];
    %guard =[FallForward',  FallBackward'];
    guard = FallBackward';
    value=       guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);
end