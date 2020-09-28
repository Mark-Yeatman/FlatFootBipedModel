function outputs = StepOutputs(t,y,phase_outputs,xin)
global flowdata
    if flowdata.Flags.step_done
        outputs.steplength = getStepLength(xin,y(end,:));
        outputs.speed = outputs.steplength/(max(t)-min(t));
    else
        outputs.steplength = nan;
        outputs.speed = nan;
    end

    outputs.phases={};
    outputs.COP = [];
    outputs.u = [];
    outputs.u_pd = [];
    outputs.GRF = [];
    outputs.FootClearance = [];
    outputs.MechE =[];
    outputs.Work =[];
    for i=1:length(phase_outputs)
        data = phase_outputs{i};
        %over step data
        outputs.COP = [outputs.COP; data{1}.COP];   
        outputs.u = [outputs.u; data{1}.u];   
        %outputs.u_pd = [outputs.u_pd; data{1}.u_pd];   
        outputs.GRF = [outputs.GRF; data{1}.GRF];   
        outputs.FootClearance = [outputs.FootClearance, data{1}.FootClearance];  
        outputs.MechE = [outputs.MechE, data{1}.MechE];
        outputs.Work =  [outputs.Work, data{1}.Work];
        %over phase data
        outputs.phases{i} = struct('phase_name',data{1}.name,...
                                   'tstart',data{2},...
                                   'tend',data{3},...
                                   'terminal_impact',data{4});
        outputs.phases{i}.configs = data{1}.configs;
        outputs.phases{i}.x_start = data{1}.x_start;

        if strcmp(outputs.phases{i}.phase_name ,'Flat')
            outputs.minFootClearance = data{1}.minFC;
        end
    end

    if ~isfield(outputs, 'minFootClearance')
        outputs.minFootClearance = nan;
    end
end