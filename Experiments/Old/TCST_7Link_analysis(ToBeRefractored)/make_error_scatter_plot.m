global param_error_per 
global M1 M2 Mp Mf la l1 l2 lf I1x I2x Ipx

load limitcycle.mat
initialize;
gainratios = diag([0,0,0,1,1,0,0,0]);
kd = 1;
Efunc_b = @Energy_Sub_ParamError;
silent  = true;

error_results = zeros(30,2);
for i = 1:30
    seed = rand([1,11])*0.3;
    error = seed.*[M1,M2,Mp,Mf,la,l1,l2,lf,I1x,I2x,Ipx];
    param_error_per  = 1 + seed;
    Eref_b = [ Energy_Sub_ParamError(xout(1,:));Energy_Sub_ParamError(xout(534,:));Energy_Sub_ParamError(xout(887,:))];
    [N,A,~,~,~]=gait_sensitivity_norm(xi,g0,3);
    error_results(i,:) = [norm(error),1/N];  
end
    
