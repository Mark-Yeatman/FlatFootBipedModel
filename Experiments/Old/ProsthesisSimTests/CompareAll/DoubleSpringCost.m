function cost = DoubleSpringCost(parameters)
    %DOUBLESPRINGCOST Summary of this function goes here
    %   Detailed explanation goes hered
    global human_torques human_trajectories flowdata prob
    
    k1 = parameters(1);
    k2 = parameters(2);
    L0_1 = parameters(3);
    L0_2 = parameters(4);
    
    for i = 1:length(human_trajectories)  
        %heel spring
        flowdata.Parameters.SLIP.L0 = L0_1;
        flowdata.Parameters.SLIP.k = k1;
        lf = flowdata.Parameters.Biped.lf; %save for toe spring
        flowdata.Parameters.Biped.asvector(11) =  0;
        u1 = LinSpring_Flat(human_trajectories(i,:)' );
    
        %toe spring
        flowdata.Parameters.SLIP.L0 = L0_2;
        flowdata.Parameters.SLIP.k = k2;
        flowdata.Parameters.Biped.asvector(11) =  lf;
        u2 = LinSpring_Flat(human_trajectories(i,:)' );
        
        switch prob
            case 'knee'
                %just knee
                u(i,1) = u1(5)' + u2(5)';
            case 'ankle'
                %just ankle
                u(i,1) = u1(4)' + u2(4)';
            
            case 'both'
                %both
                u(i,:) = u1(4:5)' + u2(4:5)';
        end
    end
    
    cost = norm( u - human_torques, 2);          
end

