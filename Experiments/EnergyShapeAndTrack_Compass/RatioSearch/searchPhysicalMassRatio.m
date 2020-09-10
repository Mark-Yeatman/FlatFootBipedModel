flowdata.Controls.Internal = {};

Ms = 5;
Mh = Ms*ratio;
Isz = 0;
a = 0.5;
b = 0.5;
g = 9.81;
params_keys = {'Mh', 'Ms', 'Isz', 'a', 'b', 'g'};
params_values = {Mh, Ms, Isz, a, b, g};
flowdata.Parameters.Biped = containers.Map(params_keys,params_values);