function [value, isterminal, direction] = guardFlight(~, x)
global eqnhandle lf dim slope ignore
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);
 
    temp = swingHeelClearance(q,qdot);
    sw_heel_height = temp(1);
    
    foot_angle = slope - x(3);

    if ignore
        value=[];
        isterminal=[];
        direction=[];
    else
        [value, isterminal, direction] = constraintValidation(0,x);
    end
    %             to_flat        , to_toe           , to_double_support, to_flight     ,to_heel ,%validations
    value=       [foot_angle     , x(2)              , 0                , 0            ,0       ,value]; 
    isterminal = [x(2)<1e-2      , foot_angle>slope  , 0                , 0            ,0       ,isterminal];
    direction =  [0              , -1                , 0                , 0            ,0       ,direction];

end