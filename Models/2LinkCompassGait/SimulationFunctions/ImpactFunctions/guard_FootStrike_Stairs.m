function [value, isterminal, direction] = guard_FootStrike_Stairs(t, x)  
    global flowdata  
    params = cell2mat(flowdata.Parameters.Biped.values);
    deltay = Foot_Sw_pos_func(x,params)-Foot_St_pos_func(x,params);
    sh = flowdata.Parameters.Environment.StairHeight;

    %value, isterminal, direction
    FootStrike  = [deltay(2,4) + sh, x(4)>0.1, -1];
    guard =FootStrike';
    %guard =[FootStrike',  COPatLead'];
    value=       guard(1,:);
    isterminal = guard(2,:);
    direction =  guard(3,:);
end