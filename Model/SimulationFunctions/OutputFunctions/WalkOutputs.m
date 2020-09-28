function outputs = WalkOutputs(t,x,stepOutputs)
    outputs.COP = [];   
    outputs.u = [];  
    outputs.GRF = [];  
    outputs.u_pd = [];
    outputs.FootClearance = [];
    outputs.MechE =[];
    outputs.Work =[];
    for i=1:length(stepOutputs)
        data = stepOutputs{i};
        
        %over walk data
        outputs.COP = [outputs.COP; data{1}.COP];  
        outputs.u = [outputs.u; data{1}.u]; 
        %outputs.u_pd = [outputs.u_pd; data{1}.u_pd];
        outputs.FootClearance = [outputs.FootClearance, data{1}.FootClearance];  
        outputs.MechE = [outputs.MechE, data{1}.MechE];
        outputs.Work =  [outputs.Work, data{1}.Work];
        outputs.GRF = [outputs.GRF; data{1}.GRF];   
        
        %over step data
        outputs.steps{i}.phases = data{1}.phases;
        outputs.steps{i}.steplength = data{1}.steplength;
        outputs.steps{i}.speed = data{1}.speed;
        %outputs.steps{i}.minFootClearance = data{1}.minFootClearance;
        tlast = data{2};
        for j = 1:length(outputs.steps{i}.phases)    %Iterate over phases
            outputs.steps{i}.phases{j}.tstart = outputs.steps{i}.phases{j}.tstart + tlast;
        end
    end
end