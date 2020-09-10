% TEST and USAGE
% use ctrl+C to stop BSA, and get globalminimum and globalminimizer from workspace of MATLAB


example;
FncNumber=1; % FncNumber={1=griewank, 2=rastrigin, 3=rosenbrock, 4=FoxHoles, 5=ackley}
settingOfBenchmarkFnc(FncNumber); bsa(fnc,[],30,dim,1,low,up,1e6)


BSA|    1 -----> 520.5563288824233700
BSA|    2 -----> 520.5563288824233700
BSA|    3 -----> 520.5563288824233700
...
BSA| 3226 -----> 0.0000000000000001
BSA| 3227 -----> 0.0000000000000000
