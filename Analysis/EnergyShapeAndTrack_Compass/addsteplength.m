exp_names = fieldnames(grid_results);
for  i=1:length(exp_names)
    exp_dat = grid_results.(exp_names{i});
    grid_results.(exp_names{i}).steplength = {};
    for j = 1:length(exp_dat.out_extra)
        if isfield(exp_dat.out_extra{j}.steps{1},'steplength')
            grid_results.(exp_names{i}).steplength{j} = exp_dat.out_extra{j}.steps{1}.steplength;
        else
            outputs = StepOutputs(exp_dat.tout{j},exp_dat.xout{j},{},exp_dat.State{j}.xi);
            grid_results.(exp_names{i}).steplength{j} = outputs.steplength;
        end
    end
end