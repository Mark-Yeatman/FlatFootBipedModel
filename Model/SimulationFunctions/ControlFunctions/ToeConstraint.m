function u = ToeConstraint(t,x,ui)
    %FORCECONTROL Summary of this function goes here
    %   Detailed explanation goes here
%% Simple
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    k = flowdata.Parameters.CONSTR.k;
    d = flowdata.Parameters.CONSTR.d;
     
    pToeSw = Toe_Sw_pos_func(x,params);
    pToeSw = pToeSw(1:2,4);
    
    vToeSw = Toe_Sw_vel_func(x,params);
    vToeSw = vToeSw(1:2,4);
    
    zddot_d = -k*pToeSw - d*vToeSw; 
    
        
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity
    
    J = A_Toe_func(q,qdot);
    Jdot = Adot_Toe_func(q,qdot);


      
    M = M_func(x,params);
    C = C_func(x,params);
    G = G_func(x,params); 
    B = eye(8,8);
        
    W = J*inv(M)*B;
    Q = zddot_d-Jdot*qdot + J*inv(M)*(C*qdot+G-ui);
    u = lsqminnorm(W,Q);     

end