function [xnext,valid]= ImpactValidation(xprev,xnext,F,imp_name)
global flowdata     
    
    params = cell2mat(flowdata.Parameters.Biped.values);
    if flowdata.Flags.step_done       
        %If the step is done, update x,y position to new stance foot
        nextpose = Foot_Sw_pos_func(xprev',params);            
        xnext(1:2) = nextpose(1:2,4)';
        
        %Swap locked knee 
        configs = flowdata.State.c_configs;
        flowdata.State.c_configs = {};
        if contains(configs,'KLockSt')
            flowdata.State.c_configs{end} = 'KLockSw';
        end
        if contains(configs,'KLockSw')
            flowdata.State.c_configs{end} = 'KLockSt';
        end
    end
    flowdata.setImpacts(); 
    
    %Check that impact normal forces point out of the ground
    R_gf = flowdata.getRgf();
    R_gf = R_gf(1:2,1:2);
    if length(F)>=4
       F1 = F(1:2);
       F2 = F(3:4);
       GRF1 = R_gf*F1;
       GRF2 = R_gf*F2;
    elseif length(F) >= 2
       F1 = F(1:2);
       F2 = nan(size(F1));
       GRF1 = R_gf*F1;
       GRF2 = R_gf*F2;
    end
    if GRF1(2)< 0 || GRF2(2)<0
       %warning("Impact force pulls into ground") 
    end
    
    %Unset flags, check that next state satisfy the guards, reset flags
    temp = flowdata.Flags.step_done;
    flowdata.Flags.step_done = false;
    [value, isterminal, direction] = guard(0,xnext');
    for i = 1:length(value)
       if isterminal(i) && value(i)*direction(i)>0
           warning(['Guard violated post-impact by: ',flowdata.Impacts{i}.name])
           flowdata.setNextPhaseAndConfig(i);
       end
    end
    flowdata.Flags.step_done = temp;    
    
    %Check if constraints are valid
    valid = true;   
    [A,~] = flowdata.getConstraintMtxs(xprev',params);
    if rank(A) >= flowdata.Parameters.dim/2
        valid = false;
        myprint('\nBiped is over constrained, skipping DSupp')
        flowdata.State.c_phase = 'SSupp';
        flowdata.setImpacts()
        %flowdata.Flags.terminate = true;
    end
          
end