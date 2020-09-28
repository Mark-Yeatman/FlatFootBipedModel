function [u,lambda_d] = SLIP_Control(t,x)
    %SLIP_CONTROL Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;
    params = flowdata.Parameters.Biped.asvec;
    k = flowdata.Parameters.SLIP.k;
    L0 = flowdata.Parameters.SLIP.L0;
    
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity

    %Contact constraints 
    [A,Adot] = flowdata.getConstraintMtxs(q,qdot);

    M = M_func(x,params);
    C = C_func(x,params);
    G = G_func(x,params); 
    
    %swing foot is leading during double support (Swing Heel in contact, Stance Toe in contact)
    %trailing toe (Stance toe) constraint is first in list for A_DSupp_func
    
    com_pose = COM_pos_func(x,params)';   
    %%Changed stance and swing legs
    
    switch flowdata.State.c_phase
        case "Heel"
            v1 = com_pose(1:2)-x(1:2);
            theta_1 = atan2(v1(2),v1(1));
            L1 = norm(v1,2);
            S1 = k*(L1-L0)*[cos(theta_1);sin(theta_1)];

            G1 = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal];
            D = inv(A*inv(M)*A')*(A*inv(M)*(-C*qdot-G) + Adot*qdot); %#ok<*MINV>
            lambda_d = S1+G1;
            B = flowdata.Parameters.B;
            u = B*((inv(A*inv(M)*A')*A*inv(M)*B)\(lambda_d-D));
        case "Flat"
            %calculate COP
            slope = flowdata.Parameters.Environment.slope;
            rot = [cos(slope), -sin(slope); sin(slope), cos(slope)];
            lf = flowdata.Parameters.Biped.lf;
            p = flowdata.Parameters.COP_Clock.period;
            te = flowdata.State.tend;
            pv = (p-t+te)/p;
            if pv>1;pv=1;end
            if pv<0;pv=0;end
            CoP_foot_frame = lf*(1-pv);
            
            v1 = com_pose(1:2)-inv(rot)*[-CoP_foot_frame;0];
            theta_1 = atan2(v1(2),v1(1));
            L1 = norm(v1,2);
            S1 = k*(L1-L0)*[cos(theta_1);sin(theta_1)];
            G1 = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal];
            lambda_d = S1+G1;
            
            %Should keep cop location invariant
            Fx =-lambda_d(1);
            Fy =-lambda_d(2); 
            temp = rot*[Fx;Fy];
            Ft = temp(1); Fn = temp(2);
            la = flowdata.Parameters.Biped.lf;
            lambda_d(3) =  -(CoP_foot_frame*Fn+la*Ft);
            D = inv(A*inv(M)*A')*(A*inv(M)*(-C*qdot-G) + Adot*qdot); %#ok<*MINV>
            B = flowdata.Parameters.B;
            u = B*((inv(A*inv(M)*A')*A*inv(M)*B)\(lambda_d-D));
        case "Toe"
            toe_st_pose = Toe_St_pos_func(x,params);
            v1 = com_pose(1:2)-toe_st_pose(1:2,4);
            theta_1 = atan2(v1(2),v1(1));
            L1 = norm(v1,2);
            S1 = k*(L1-L0)*[cos(theta_1);sin(theta_1)];

            G1 = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal];
            D = inv(A*inv(M)*A')*(A*inv(M)*(-C*qdot-G) + Adot*qdot); %#ok<*MINV>
            lambda_d = S1+G1;
            B = flowdata.Parameters.B;
            u = B*((inv(A*inv(M)*A')*A*inv(M)*B)\(lambda_d-D));
        case "DSuppToeHeel"
            %the constraint function should be 
            % fx_toesw
            % fy_toese
            % fx_heelst
            % fy_heelst
            toe_sw_pose = Toe_Sw_pos_func(x,params);
            
            v1 = com_pose(1:2)-x(1:2);
            theta_1 = atan2(v1(2),v1(1));
            L1 = norm(v1,2);
            S1 = k*(L1-L0)*[cos(theta_1);sin(theta_1)];
                
            v2 = com_pose(1:2)-toe_sw_pose(1:2,4);
            theta_2 = atan2(v2(2),v2(1));
            L2 = norm(v2,2);
            S2 = k*(L2-L0)*[cos(theta_2);sin(theta_2)];
            
            %weighting should allow trailing leg to lift when spring force
            %goes to 0
            G1 = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal]*norm(S1)/(norm(S1)+norm(S2));
            G2 = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal]*norm(S2)/(norm(S1)+norm(S2));
            
            kappa = flowdata.Parameters.KPBC.kappa;
            Eref = flowdata.State.Eref;
            vCom = norm(COM_vel_func(x,params));
            Mtotal = flowdata.Parameters.Biped.MTotal;
            g = flowdata.Parameters.Environment.g;
            E = 1/2*k*(L1-L0)^2 + 1/2*k*(L2-L0)^2 + 1/2*Mtotal*vCom^2 + Mtotal*g*com_pose(2);
            com_vel = COM_vel_func(x,params);
            KPBCx = kappa*(E-Eref)*com_vel(1);
            KPBCy = kappa*(E-Eref)*com_vel(2);
            KPBC1 = [KPBCx;KPBCy]*norm(S1)/(norm(S1)+norm(S2));
            KPBC2 = [KPBCx;KPBCy]*norm(S2)/(norm(S1)+norm(S2));
            
            D = inv(A*inv(M)*A')*(A*inv(M)*(-C*qdot-G) + Adot*qdot);
          
            lambda_d = [S2+G2+KPBC2;S1+G1+KPBC1];
            B = flowdata.Parameters.B;
            u = B*((inv(A*inv(M)*A')*A*inv(M)*B)\(lambda_d-D));

            Ad = A;
            Ao=[];
        case "DSuppToeFlat"
            %the constraint function should be 
            % fx_toesw
            % fy_toese
            % fx_heelst
            % fy_heelst
            % m_anklest
            slope = flowdata.Parameters.Environment.slope;
            la = flowdata.Parameters.Biped.la;
            rot = [cos(slope), -sin(slope); sin(slope), cos(slope)];
            lf = flowdata.Parameters.Biped.lf;
            p = flowdata.Parameters.COP_Clock.period;
            CoP_foot_frame = 0;
            
            v1 = com_pose(1:2)-x(1:2);%inv(rot)*[-CoP_foot_frame;0];
            theta_1 = atan2(v1(2),v1(1));
            L1 = norm(v1,2);
            S1 = k*(L1-L0)*[cos(theta_1);sin(theta_1)];
            
            toe_sw_pose = Toe_Sw_pos_func(x,params);
            v2 = com_pose(1:2)-toe_sw_pose(1:2,4);
            theta_2 = atan2(v2(2),v2(1));
            L2 = norm(v2,2);
            S2 = k*(L2-L0)*[cos(theta_2);sin(theta_2)];
            G1 = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal]*norm(S1)/(norm(S1)+norm(S2));
            G2 = -[0;flowdata.Parameters.Environment.g*flowdata.Parameters.Biped.MTotal]*norm(S2)/(norm(S1)+norm(S2));
            
            kappa = flowdata.Parameters.KPBC.kappa;
            Eref = flowdata.State.Eref;
            vCom = norm(COM_vel_func(x,params));
            Mtotal = flowdata.Parameters.Biped.MTotal;
            E = 1/2*k*(L1-L0)^2 + 1/2*k*(L2-L0)^2 + 1/2*Mtotal*vCom^2 + Mtotal*flowdata.Parameters.Environment.g*com_pose(2);
            com_vel = COM_vel_func(x,params);
            KPBCx = kappa*(E-Eref)*com_vel(1);
            KPBCy = kappa*(E-Eref)*com_vel(2);
            KPBC1 = [KPBCx;KPBCy]*norm(S1)/(norm(S1)+norm(S2));
            KPBC2 = [KPBCx;KPBCy]*norm(S2)/(norm(S1)+norm(S2));
            
            lambda_d = [S2+G2+KPBC2;S1+G1+KPBC1];
            Ad = A(1:4,:);
            Ao= A(5,:);
            %A = A(1:4,:);
            %Adot = A(1:4,:);
            %Should keep cop location invariant

    end
    Jdot= COM_Jacobian_dot_func(x,params);
    Jdot = Jdot(1:2,:);
    J = COM_Jacobian_func(x,params);
    J = J(1:2,:);
    B = flowdata.Parameters.B;
    Mtotal = flowdata.Parameters.Biped.MTotal;
    g = flowdata.Parameters.Environment.g;
    zd = (-S1-S2-[0;Mtotal*g]-[KPBCx;KPBCy])/Mtotal;
    W = [A;J]*inv(M)*[B,Ao'];
    temp = pinv(W)*([-Adot*qdot;zd-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G+Ad'*lambda_d));
    %W = [A;J]*inv(M)*[B,A'];
    %temp = pinv(W)*([-Adot*qdot;F-Jdot*qdot] + [A;J]*inv(M)*(C*qdot+G));
    
    u = B*temp(1:rank(B));
end

