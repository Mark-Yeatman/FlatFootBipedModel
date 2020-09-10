function [xnext,valid]= ImpactValidation(xprev,xnext,imp_name)
global flowdata     

    valid = true;    
    [A,~] = flowdata.getConstraintMtxs(xprev');
    if rank(A) >= flowdata.Parameters.dim/2
        valid = false;
        myprint('\nBiped is over constrained')
    end 
    
    if flowdata.Flags.step_done
       Heel_pose = Heel_Sw_pos_func(xprev');
       xnext(1:2) =  Heel_pose(1:2,4);
    end
    
    flowdata.State.Einit = flowdata.E_func(xnext');
end