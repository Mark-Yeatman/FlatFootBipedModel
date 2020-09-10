%Add Control Function
flowdata.Controls.Internal = {@Shaping, @KPBC};

Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = 0.5;
g = 9.81;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);

Mh = 10;
Ms = 5;
Isz = 0;
a = 0.5;
b = a*ratio;
g = 9.81;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Shaping = containers.Map(params_keys,params_values);

flowdata.Parameters.KPBC.k = 10;
flowdata.Parameters.KPBC.omega = diag([0,0,1,0]);
flowdata.Parameters.KPBC.sat = inf;

shape_params = cell2mat(flowdata.Parameters.Shaping.values);
flowdata.State.Eref = flowdata.E_func(xi',shape_params);

temp = find((abs([grid_results.physical_length_ratio.ratio{:}]-ratio)<1e-6),1);
flowdata.Parameters.Eref_Update.vref = grid_results.physical_length_ratio.speed{temp};
flowdata.Parameters.Eref_Update.k = 5;
flowdata.Parameters.Eref_Update.flag = "speed";