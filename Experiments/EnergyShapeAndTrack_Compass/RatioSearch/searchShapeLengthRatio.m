flowdata.Controls.Internal = {@Shaping};

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