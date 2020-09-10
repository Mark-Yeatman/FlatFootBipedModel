function outputs = StepOutputs(t,y,phase_outputs,xin)
    global flowdata
    params = cell2mat(flowdata.Parameters.Biped.values());
    outputs.phases={};
    outputs.COP = [];
    outputs.u = [];
    outputs.GRF = [];
    outputs.FootClearance = [];
    outputs.E = [];
    outputs.Eref = [];
    %temp = Hip_pos_func(y(end,:)',params) - Hip_pos_func(xin',params);
    %outputs.steplength = norm(temp(:,4));
    temp = COM_pos_func(y(end,:)',params) - COM_pos_func(xin',params);
    outputs.steplength = norm(temp);
    outputs.speed = outputs.steplength /(max(t)-min(t));

    
    %update Eref based on Goswami update law
    if isfield(flowdata.Parameters,'Eref_Update')
        outputs.Eref = flowdata.State.Eref;
        if isfield(flowdata.Parameters.Eref_Update,'flag')
            if strcmp(flowdata.Parameters.Eref_Update.flag ,"speed")
                n = flowdata.Parameters.Eref_Update.k;
                v = flowdata.Parameters.Eref_Update.vref;
                flowdata.State.Eref = flowdata.State.Eref + n*(v-outputs.speed);
            end
        end
    end
    for i=1:length(phase_outputs)
        data = phase_outputs{i};
        %over step data
        %outputs.COP = [outputs.COP; data{1}.COP];   
        outputs.u = [outputs.u; data{1}.u];   
        outputs.GRF = [outputs.GRF; data{1}.GRF];   
        outputs.FootClearance = [outputs.FootClearance, data{1}.FootClearance];  
        outputs.E = [outputs.E; data{1}.E];  
        outputs.Eref = [outputs.Eref; data{1}.Eref]; 
        
        %over phase data
        outputs.phases{i} = struct('phase_name',data{1}.name,...
                                   'tstart',data{2},...
                                   'tend',data{3},...
                                   'impact_name',data{4});
    end

end