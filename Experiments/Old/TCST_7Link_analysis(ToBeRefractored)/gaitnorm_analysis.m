kd =0;[N,A,B,C,D]=gait_sensitivity_norm(xi,g0,1);
temp = eig(A);
disp(strcat('For kd = 0, 1/N is: ', num2str(1/N), ' with A max eigs: ' , num2str(max(abs(temp))) ));
kd =10;[N,A,B,C,D]=gait_sensitivity_norm(xi,g0,1);
temp = eig(A);
disp(strcat('For kd = 10, 1/N is: ', num2str(1/N), ' with A max eigs: ' , num2str(max(abs(temp))) ));