function guard = constraintValidation(~, x)
% This functions defines conditions that terminate biped walking in all
% scenarios
%
global flowdata  
    dim = flowdata.Parameters.dim;

    FallForward  = [x(3) - deg2rad(-90), 0, 0];
    FallBack     = [x(3) - deg2rad(90), 0, 0];
    HipOut       = [(deg2rad(90) - abs(x(5))), 0, 0];
    Stopped      = [ norm(x)> 1e-6, 0,0];
    
    guard = [FallForward',  FallBack', HipOut', Stopped'];
%     value =      guard(1,:);
%     isterminal = guard(2,:);
%     direction =  guard(3,:);
end