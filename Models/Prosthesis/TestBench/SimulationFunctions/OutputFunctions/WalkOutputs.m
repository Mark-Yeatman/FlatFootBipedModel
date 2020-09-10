function outputs = WalkOutputs(t,x,stepOutputs)
global flowdata
    outputs = [];
    %outputs.GenE = zeros(length(x),1);
    outputs.u = []; 
    outputs.W = []; 
    params = flowdata.Parameters.Dynamics.asvector;
    for i = 1:length(x)
        outputs.E(i) = flowdata.E_func(x(i,:)',params );
    end
  
    for i=1:length(stepOutputs)
        data = stepOutputs{i};        
        %over walk data
        outputs.u = [outputs.u; data{1}.u]; 
        outputs.W = [outputs.W; data{1}.W]; 
    end
    
end