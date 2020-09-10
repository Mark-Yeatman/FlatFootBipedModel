function CV = constraintValidation(~, x)
% This functions defines conditions that terminate biped walking in all
% scenarios
%
global flowdata 
    
    Floor  =        [x(2),1, 0];
    ForwardSpeed  = [x(3),1, 0];
%     
%     guard = [Floor',ForwardSpeed'];
%     value =      guard(1,:);
%     isterminal = guard(2,:);
%     direction =  guard(3,:);
    CV = [Floor;ForwardSpeed];
end