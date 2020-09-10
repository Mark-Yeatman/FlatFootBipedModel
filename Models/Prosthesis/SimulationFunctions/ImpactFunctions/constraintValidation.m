function [value, isterminal, direction] = constraintValidation(~, x)
% This functions defines conditions that terminate biped walking in all
% scenarios
%
global eqnhandle lf dim slope mu contact
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);
     
    Lambda = feval(eqnhandle, 0, x, 'L');

    if strcmp(contact,'DSupp')
        Fheel_x = Lambda(3);
        Fheel_y = Lambda(4);
        [Fheel_t,Fheel_n] = ForceTanNorm(slope,Fheel_x,Fheel_y);
        value = [x(3) - pi/2, x(3)+pi/2,0]; %[Falls backward, Falls forward, Normal Force is not positive, Tangent Force is larger than friction allows]
        isterminal = [1,1, abs(Fheel_n)<abs(Fheel_t*mu)];
        direction = [-1,1,0]; 
    elseif strcmp(contact,'Flight')
        value = [x(3) - pi/2, x(3)+pi/2]; %[Falls backward, Falls forward, Normal Force is not positive, Tangent Force is larger than friction allows]
        isterminal = [1,1];
        direction = [-1,1]; 
    else
        Fx = Lambda(1);
        Fy = Lambda(2);
        [Ft,Fn] = ForceTanNorm(slope,Fx,Fy);
        value = [x(3) - pi/2, x(3)+pi/2, 0]; %[Falls backward, Falls forward, Normal Force is not positive, Tangent Force is larger than friction allows]
        isterminal = [1,1,mu*Fn<abs(Ft)];
        direction = [-1,1,0]; 
    end
end