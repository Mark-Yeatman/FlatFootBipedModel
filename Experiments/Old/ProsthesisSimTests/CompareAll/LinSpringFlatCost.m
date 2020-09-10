function cost = LinSpringFlatCost(parameters)
    %DOUBLESPRINGCOST Summary of this function goes here
    %   Detailed explanation goes hered
    global human_torques human_trajectories flowdata prob
    
    k = parameters(1);
    L0 = parameters(2);
    lf = parameters(3);
    
    u = zeros(length(human_trajectories),2);
    for i = 1:length(human_trajectories)  
        %heel spring
        flowdata.Parameters.SLIP.L0 = L0;
        flowdata.Parameters.SLIP.k = k;
        flowdata.Parameters.Biped.asvector(11) =  lf;
        u1 = LinSpring_Flat(human_trajectories(i,:)' );
            
        switch prob
            case 'knee'
                %just knee
                u(i,1) = u1(5)';
            case 'ankle'
                %just ankle
                u(i,1) = u1(4)';
            
            case 'both'
                %both
                u(i,:) = u1(4:5)';
        end
    end
    
    cost = norm( u - human_torques, 2);          
end

