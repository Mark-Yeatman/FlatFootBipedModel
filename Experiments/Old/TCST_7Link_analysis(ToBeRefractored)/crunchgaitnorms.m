%make sure to set control energy parameters to b in dynamics2 and step2
initialize;
gainratios = diag([0,0,0,1,1,0,0,0]);
silent  = true;
results.uncontrolled = [];
results.centralized = [];
results.decentralized = [];
results.prosthesis = [];

%uncontrolled
kd = 0;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.uncontrolled.eigs = max(abs(eig(A)));  
results.uncontrolled.gaitnormrecep = 1/N;  

%Centralized
Eref_b = [4.600056699405806e+02; 4.643263254745372e+02; 4.560139273082979e+02];
Efunc_b = @Energy_Total

kd = 0.01;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.centralized.kd_0x01.eigs = max(abs(eig(A)));  
results.centralized.kd_0x01.gaitnormrecep = 1/N;  

kd = 1;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.centralized.kd_1.eigs = max(abs(eig(A)));  
results.centralized.kd_1.gaitnormrecep = 1/N;  

kd = 10;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.centralized.kd_10.eigs = max(abs(eig(A)));  
results.centralized.kd_10.gaitnormrecep = 1/N;  

%Decentralized
Eref_b = [ 5.092636864146643e+02;5.032885594661856e+02;5.064078133352847e+02];
Efunc_b = @Energy_Sub

kd = 0.01;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.decentralized.kd_0x01.eigs = max(abs(eig(A)));  
results.decentralized.kd_0x01.gaitnormrecep = 1/N;  

kd = 1;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.decentralized.kd_1.eigs = max(abs(eig(A)));  
results.decentralized.kd_1.gaitnormrecep = 1/N;  

kd = 10;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.decentralized.kd_10.eigs = max(abs(eig(A)));  
results.decentralized.kd_10.gaitnormrecep = 1/N;  

%Prosthesis
Eref_b = [12.276974255783596;11.680585696493461; 12.325982058788670];
Efunc_b = @Energy_Pros

kd = 0.01;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.prosthesis.kd_0x01.eigs = max(abs(eig(A)));  
results.prosthesis.kd_0x01.gaitnormrecep = 1/N;  

kd = 1;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.prosthesis.kd_1.eigs = max(abs(eig(A)));  
results.prosthesis.kd_1.gaitnormrecep = 1/N;  

kd = 10;
[N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
results.prosthesis.kd_10.eigs = max(abs(eig(A)));  
results.prosthesis.kd_10.gaitnormrecep = 1/N;  