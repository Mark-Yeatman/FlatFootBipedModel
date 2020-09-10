load('grid_results');
results_name = 'shape_mass_ratio_epbc_ball';
param_update_script = 'searchShapeMassRatioEPBC';
ratio = 1.2;
vector = boolean([0,0,1,1,0,0,1,1]);

initializeCompassGaitLimitCycle
run(param_update_script)
flowdata.Controls.Internal ={@Shaping};
i = find((abs([grid_results.(results_name).ratio{:}]-ratio)<1e-6),1);
xi = grid_results.(results_name).State{i}.xi;
flowdata.State = grid_results.(results_name).State{i}.extra;
[fstate, xout, tout, out_extra] = walk(xi,1);

flowdata.Parameters.KPBC.Eref.SSupp = flowdata.State.Eref;
maxeig = max(abs(eigenmap(fstate,1,1,vector)));
stable = maxeig < 1