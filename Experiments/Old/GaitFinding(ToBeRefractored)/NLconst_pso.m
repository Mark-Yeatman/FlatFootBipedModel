function [c,ceq] = NLconst_pso(v)
%NLconst_fmincon Constraints for optimization procedure to find a stable limit
%cycle for a locked knee biped.
%   Constraints: 
%       trailing foot is in ground contact at start, clearance = 0
%       is moving away from the ground, fp_sw_v(2,4) > 0
%       is actually behind the stance foot. foot_dist > 0.2
%
    global flowdata

    x = zeros(1,12);
    x(3) = v(1);    %stance ankle
    x(5) = v(2);    %hip 
    x(3+6) = v(3);
    x(5+6) = v(4);
    
    fp_sw_h = Foot_Sw_pos_func(x'); %swing foot position in homogenous coordinates
    fp_st_h = Foot_St_pos_func(x');
    foot_dist = norm( fp_st_h(:,4) - fp_sw_h(:,4) );
    
    fp_sw_v = Hip_vel_func(x');
    fp_sw_v = flowdata.getRgf()*fp_sw_v; %rotate into ground frame

    %clearance = swingFootClearance(x');
       
    ceq = [];
    c = [ 0.2 - foot_dist, -fp_sw_v(2,4)];
end