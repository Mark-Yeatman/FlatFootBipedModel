function outputs = PhaseOutputs(t,y,xin)
global flowdata
    outputs = [];
    outputs.u = zeros(length(y),flowdata.Parameters.dim/2);
    for i = 1:length(y)
        outputs.u(i,:) = flowdata.eqnhandle(t(i),y(i,:)','u');
    end
end