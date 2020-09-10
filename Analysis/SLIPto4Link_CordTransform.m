load MassInertiaGeometryCompass.mat
load SLIP_Walking_Sim_outputs.mat
indexa = find(tout==out_extra.steps{1}.phases{2}.tstart,1);
indexf = find(tout==out_extra.steps{1}.phases{2}.tend,1);
za = xout(indexa,:);
zf = xout(indexf,:);
xa = CordTransform(za,out_extra.steps{1}.phases{2}.foot_pos_1,out_extra.steps{1}.phases{2}.foot_pos_2,ls,lt);
xf = CordTransform(zf,out_extra.steps{1}.phases{2}.foot_pos_1,out_extra.steps{1}.phases{2}.foot_pos_2,ls,lt);
function [xa] = CordTransform(z,pf1,pf2,ls,lt)
    %pf1 is lead foot during double support
    syms r x y L1 L2 rdot xdot ydot real

    fa = (L1^2 + L2^2 - r^2)/(2*L1*L2);
    a = acos(fa);
    fb =  (r^2 + L1^2 - L2^2)/(2*L1*r);
    b = acos(fb);
    at2 = atan2(y,x);

    %find positions
    ph = z(1:2);
    r1 = norm(ph-pf1);
    r2 = norm(ph-pf2);

    a_subs = eval(subs(a,{r,L1,L2},[r1,ls,lt]));
    b_subs = eval(subs(b,{r,L1,L2},[r1,ls,lt]));
    pl = ph-pf1;
    t1 = eval(subs(at2,{x,y},[pl(1),pl(2)])) - b_subs;
    t2 = pi - a_subs;

    c_subs = eval(subs(a,{r,L1,L2},[r2,ls,lt]));
    d_subs = eval(subs(b,{r,L1,L2},[r2,ls,lt]));
    pt = ph - pf2;
    t3 = eval(subs(at2,{x,y},[pt(1),pt(2)])) - d_subs;
    t4 = pi - c_subs;
    xi_calc = [0,0,t3-pi/2,t4,t1+t2-t3-t4,-t2];
    
    %find velocities
    J_f_st = Foot_St_Jacobian_func(xi_calc');
    J_f_sw = Foot_Sw_Jacobian_func(xi_calc');
    J_h = Hip_Jacobian_func(xi_calc');
    J = [J_f_st(1:2,:);J_f_sw(1:2,:);J_h(1:2,:)];
    qidot = inv(J)*[0;0;0;0;z(3);z(4)];
    
    %swap coordiantes
    dim = length(xi_calc)*2;

    R = [zeros(1,dim/2);
    zeros(1,dim/2);
    0,0,ones(1,dim/2-2);[zeros(dim/2-3,3),flip(-1*eye(dim/2-3),1)]];

    qi = xi_calc(1:6);
 
    xa = [(R*qi')',(R*qidot)'];
end