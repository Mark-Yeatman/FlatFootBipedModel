function u = Oscillator(x)
    %OSCILLATOR Makes hip joint a nonlinear oscillator
    %   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;
    
    u = zeros(dim/2,1);
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim);
    E =  flowdata.Parameters.Oscillator.E;
    k = flowdata.Parameters.Oscillator.k;
    q0 = flowdata.Parameters.Oscillator.q0;
    u(4) = -qdot(4)*(qdot(4)^2+q(4)^2 - E) - k*(q(4)-q0);
end

