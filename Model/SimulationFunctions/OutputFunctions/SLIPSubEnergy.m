function E= SLIPSubEnergy(t,y,~)
    %EN Summary of this function goes here
    %   Detailed explanation goes here
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    
    E = zeros(size(t));
    Mt = flowdata.Parameters.Biped.MTotal;
    g = flowdata.Parameters.Environment.g;
    
    if isfield(flowdata.Parameters,"Cntr")
        k = flowdata.Parameters.Cntr.k;
        L0 = flowdata.Parameters.Cntr.L0;
        lf = flowdata.Parameters.Biped.lf;
        CoP_foot_frame = lf/2;

        for i=1:length(t)
           x = y(i,:)';
           com_pos = COM_pos_func(x,params)';
           com_vel = COM_vel_func(x,params)';
           v1 = com_pos(1:2)-(x(1:2)+[CoP_foot_frame;0]);
           h = com_pos(2) - - flowdata.State.PE_datum; 
           E(i) = 1/2*norm(com_vel)^2*Mt + Mt*g*h + 1/2*k*v1(1)^2 + 1/2*k*(v1(2)-L0)^2; 
        end
        
    elseif isfield(flowdata.Parameters,"SLIP")
        k = flowdata.Parameters.SLIP.k;
        L0 = flowdata.Parameters.SLIP.L0;

        for i=1:length(t)
            x = y(i,:)';
            x(2) = x(2) - flowdata.State.PE_datum;
            com_pos = COM_pos_func(x,params)';
            com_vel = COM_vel_func(x,params)';
            v1 = com_pos(1:2)-x(1:2);
            L1 = norm(v1,2);

            toe_sw_pose = Toe_Sw_pos_func(x,params);
            v2 = com_pos(1:2)-toe_sw_pose(1:2,4);
            L2 = norm(v2,2);
            
            h = com_pos(2) - flowdata.State.PE_datum; 
            
            E(i) = 1/2*norm(com_vel)^2*Mt + Mt*g*h + 1/2*k*(L1-L0)^2 + 1/2*k*(L2-L0)^2; 
        end
    end
    

end

