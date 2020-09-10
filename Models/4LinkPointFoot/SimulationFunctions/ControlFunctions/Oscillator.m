function u = Oscillator(x)
    %OSCILLATOR Makes hip joint a nonlinear oscillator
    %   Detailed explanation goes here
    global flowdata
    dim = flowdata.Parameters.dim;
    
    u = zeros(dim/2,1);
    if strcmp(flowdata.State.c_phase,"SSupp") || strcmp(flowdata.State.c_phase,"DSupp")
        q = x(1:dim/2);
        qdot = x(dim/2+1:dim);
        E =  flowdata.Parameters.Oscillator.E;
        k = flowdata.Parameters.Oscillator.k;
        q0 = flowdata.Parameters.Oscillator.q0;
        u(5) = -qdot(5) * (1/2*k*(qdot(5)-q0)^2 + q(5)^2 - E) - k*(q(5)-q0);
        %u(5) = - k*(q(5)-q0);
    end
end

