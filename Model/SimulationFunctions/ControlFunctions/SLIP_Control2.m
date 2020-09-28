function u = SLIP_Control2(t,x)
    %FORCECONTROL Summary of this function goes here
    %   Detailed explanation goes here
%% Simple
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    k = flowdata.Parameters.SLIP.k;
    L0 = flowdata.Parameters.SLIP.L0;
    Md = flowdata.Parameters.SLIP.Md;
    d = flowdata.Parameters.SLIP.d;
     
    pHip1 = Hip_pos_func(x,params);
    pHip1 = pHip1(1:2,4)-x(1:2);
    L1 = norm(pHip1);
    theta1 = atan2(pHip1(2),pHip1(1));
    Fs1 = -k*(L1-L0)*[cos(theta1);sin(theta1)];
    
    pHip2 = Hip_pos_func(x,params);
    pToeSw = Toe_Sw_pos_func(x,params);
    pHip2 = pHip2(1:2,4)-pToeSw(1:2,4);
    L2 = norm(pHip2);
    theta2 = atan2(pHip2(2),pHip2(1));
    Fs2 = -k*(L2-L0)*[cos(theta2);sin(theta2)];
    
    zddot_d = -[0;9.81]+(Fs1+Fs2)/Md; 
    
    J = Hip_Jacobian_func(x,params);
    Jdot = Hip_Jacobian_Dot_func(x,params);
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity
    
    [A,Adot] = flowdata.getConstraintMtxs(q,qdot);
    
    M = M_func(x,params);
    C = C_func(x,params);
    G = G_func(x,params); 
    B = flowdata.Parameters.B;
      
    pinvJ = pinv(J*B);
    if min(svd(J*B))<1e-2
       warning("Derp") 
    end
    J2 = pinvJ*(J*B);
    N = eye(length(J2))- J2;
    ud = B*N*-d*B'*qdot;
    
    W = [A;J]*inv(M)*[B,A'];
    Q = [Adot*qdot;zddot_d-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud);
    temp =lsqminnorm(W,Q);     
    u = B*temp(1:rank(B))+ud;
    residual = W*temp-Q;
%     if norm(residual,'inf')>1e-6
%        warning("large residual") 
%     end
%     u = B*temp(1:rank(B))
%%  Previous   
%     global flowdata
%     dim = flowdata.Parameters.dim;
%     params = flowdata.Parameters.Biped.asvec;
%     if isfield(flowdata.Parameters,"Cntr")
%         k = flowdata.Parameters.Cntr.k;
%         d = flowdata.Parameters.Cntr.d;
%         L0 = flowdata.Parameters.Cntr.L0;
%     elseif isfield(flowdata.Parameters,"SLIP")
%         k = flowdata.Parameters.SLIP.k;
%         L0 = flowdata.Parameters.SLIP.L0;
%         d = flowdata.Parameters.SLIP.d;
%     end
%     
%     q = x(1:dim/2);         %position
%     qdot = x(dim/2+1:dim);  %velocity
%     
%     [A,Adot] = flowdata.getConstraintMtxs(q,qdot);
%     M = M_func(x,params);
%     C = C_func(x,params);
%     G = G_func(x,params); 
%     
%     com_pos = COM_pos_func(x,params)';
%     com_vel = COM_vel_func(x,params)';
%     
%     MTotal = flowdata.Parameters.Biped.MTotal;
%     g = flowdata.Parameters.Environment.g;
%     
%     v1 = com_pos(1:2)-x(1:2);
%     theta_1 = atan2(v1(2),v1(1));
%     L1 = norm(v1,2);
%     S1 = -k*(L1-L0)*[cos(theta_1);sin(theta_1)];
%     
%     toe_sw_pose = Toe_Sw_pos_func(x,params);
%     v2 = com_pos(1:2)-toe_sw_pose(1:2,4);
%     theta_2 = atan2(v2(2),v2(1));
%     L2 = norm(v2,2);
%     S2 = -k*(L2-L0)*[cos(theta_2);sin(theta_2)];
%     
%     h = com_pos(2) - flowdata.State.PE_datum;            
%     E = 1/2*norm(com_vel)^2*MTotal + MTotal*g*h + 1/2*k*(L1-L0)^2 + 1/2*k*(L2-L0)^2;
%        
%     if contains(flowdata.State.c_phase,"DSupp")
%         zddot_d = -[0;g]+(S1+S2)/MTotal;   
%     else
%         kappa = flowdata.Parameters.KPBC.kappa;
%         Eref = 682.444;
%         KPBC = -kappa*(E-Eref)*[com_vel(1);com_vel(2)];
%         zddot_d = -[0;g]+(S1+KPBC)/MTotal; 
%     end
%        
%     Jdot= COM_Jacobian_dot_func(x,params);
%     Jdot = Jdot(1:2,:);
%     J = COM_Jacobian_func(x,params);
%     J = J(1:2,:);
%     B = flowdata.Parameters.B;
%     
%     pinvJ = pinv(J*B);
%     J2 = pinvJ*(J*B);
%     N = eye(length(J2))- J2;
%     ud = B*N*-d*B'*qdot;
%         
%     switch flowdata.State.c_phase
%          case {"Flat"}
%              la = flowdata.Parameters.Biped.lf;
%              CoP_foot_frame = 0.1;
%              Theta = [zeros(1,rank(B)),-la,-CoP_foot_frame,1];
%              W = [[A;J]*inv(M)*[B,A'];Theta];
%              Q  =[[Adot*qdot;zddot_d-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud);0];
%              %temp = pinv(W)*( [[Adot*qdot;zddot_d-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud);0]);
%              temp =lsqminnorm(W,Q);
%         case "DSuppToeFlat"
%             %the constraint forces should be 
%             % fx_toesw
%             % fy_toese
%             % fx_heelst
%             % fy_heelst
%             % m_anklest
%             R = norm(S2)/(norm(S1)+norm(S2));
%             la = flowdata.Parameters.Biped.lf;
%             CoP_foot_frame = 0.1;
% %             Theta = [zeros(1,rank(B)),-la,-CoP_foot_frame,1,0,0;
% %                      zeros(1,rank(B)),0,-R,0,0,1-R];
% %             c = [0;0];
%             Theta = [zeros(1,rank(B)),0,0,-la,-CoP_foot_frame,1];
%             c = 0;
%             W = [[A;J]*inv(M)*[B,A'];Theta];
%             Q = [[Adot*qdot;zddot_d-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud);c];
%             temp =lsqminnorm(W,Q);
%             %temp = pinv(W)*( [[Adot*qdot;zddot_d-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud);c]);
%         case {"DSuppToeHeel","Flight"}
%             W = [[A;J]*inv(M)*[B,A']];
%             if isempty(A)
%                 Q = [zddot_d-Jdot*qdot] + J*inv(M)*(C*qdot+G-ud);
%             else
%                 Q = [Adot*qdot;zddot_d-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud);
%             end
%             %temp = pinv(W)*( [[Adot*qdot;zddot_d-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G-ud)]);
%             temp =lsqminnorm(W,Q);
%     end
%     residual = W*temp-Q;
%     if norm(residual,'inf')>1e-6
%        warning("large residual") 
%     end
%     u = B*temp(1:rank(B))+ud;
end
