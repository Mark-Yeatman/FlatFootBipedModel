exp_names = fieldnames(grid_results);
for  i=1:length(exp_names)
    exp_dat = grid_results.(exp_names{i});
    grid_results.(exp_names{i}).TorqueSq = {};
    for j = 1:length(exp_dat.out_extra)
        %if ~isfield(exp_dat.out_extra{j}.steps{1},'TorqueSq')
            grid_results.(exp_names{i}).TorqueSq{j} = sum(trapz(exp_dat.tout{j}, exp_dat.out_extra{j}.u.^2),2);
        %end
    end
end