function [xnext,valid]= ImpactValidation(xprev,xnext,F,imp_name)
global flowdata     
    params = cell2mat(flowdata.Parameters.Biped.values);
    temp = flowdata.Flags.step_done;
    flowdata.Flags.step_done = false;
    flowdata.Flags.step_done = temp;    
 
    valid = true;
    
    [A,~] = flowdata.getConstraintMtxs(xprev',params);
    if rank(A) >= flowdata.Parameters.dim/2
        valid = false;
        myprint('\nBiped is over constrained')
    end
    
    %If the step is done, update x,y position to new stance foot
    if flowdata.Flags.step_done
        nextpose = Foot_Sw_pos_func(xprev',params);            
        xnext(1:2) = nextpose(1:2,4)';
              
        %update Eref and PE_datum
        if isfield(flowdata.Parameters,'Eref_Update')
            if strcmp(flowdata.Parameters.Eref_Update.flag,"energy")
                k = flowdata.Parameters.Eref_Update.k;
                if isfield(flowdata.Parameters,'Shaping')
                    params = cell2mat(flowdata.Parameters.Shaping.values);
                else
                    params = cell2mat(flowdata.Parameters.Biped.values);
                end

                Eprev = flowdata.E_func(xprev',params);

                %update PE_datum
                flowdata.State.PE_datum = xnext(2);
                Enext = flowdata.E_func(xnext',params);

                flowdata.State.Eref = flowdata.State.Eref + k*(Enext - Eprev); 
                
            elseif strcmp(flowdata.Parameters.Eref_Update.flag,"speed")
                flowdata.State.PE_datum = xnext(2);
                %updated in step outputs
            end
        else
            flowdata.State.PE_datum = xnext(2);
        end
        
    end

end