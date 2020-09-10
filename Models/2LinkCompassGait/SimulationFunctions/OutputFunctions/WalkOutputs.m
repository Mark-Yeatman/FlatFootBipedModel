function outputs = WalkOutputs(t,x,stepOutputs)
    global flowdata
    outputs.COP = [];   
    outputs.u = [];  
    outputs.GRF = [];  
    outputs.FootClearance = [];
    outputs.E_Nat = zeros(1,length(x));
    outputs.E_Shaped = zeros(1,length(x));
    outputs.E = [];
    outputs.Eref = [];
    outputs.HoloError=[];
    outputs.HoloError_dot=[];
    for i=1:length(stepOutputs)
        data = stepOutputs{i};
        
        %over walk data
        outputs.COP = [outputs.COP; data{1}.COP];  
        outputs.u = [outputs.u; data{1}.u]; 
        outputs.FootClearance = [outputs.FootClearance, data{1}.FootClearance];  
        outputs.GRF = [outputs.GRF; data{1}.GRF];   
        outputs.E = [outputs.E; data{1}.E];  
        outputs.Eref = [outputs.Eref; data{1}.Eref];
        
        %over step data
        outputs.steps{i}.phases = data{1}.phases;
        outputs.steps{i}.speed = data{1}.speed;
        outputs.steps{i}.steplength= data{1}.steplength;
        if isfield(flowdata.Parameters,'Eref_Update')
            outputs.steps{i}.Eref = data{1}.Eref;
        end
        tlast = data{2};
        for j = 1:length(outputs.steps{i}.phases)    %Iterate over phases
            outputs.steps{i}.phases{j}.tstart = outputs.steps{i}.phases{j}.tstart + tlast;
            outputs.steps{i}.phases{j}.tend = outputs.steps{i}.phases{j}.tend + tlast;
        end
    end
    params = cell2mat(flowdata.Parameters.Biped.values());

    for i = 1:length(x)
        outputs.E_Nat(i) = flowdata.E_func(x(i,:)',params);
        [outputs.HoloError(i),outputs.HoloError_dot(i),~,~] = getHolonomicConstraint(x(i,:)');
    end
    if isfield(flowdata.Parameters,'Shape')
        shaping_params = cell2mat(flowdata.Parameters.Shaping.values);
        for i = 1:length(x)
            outputs.E_Shaped(i) = flowdata.E_func(x(i,:)',shaping_params);
        end
    end
end

