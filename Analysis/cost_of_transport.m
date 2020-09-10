function COT = cost_of_transport(x,tau,t,mtotal,g,d)
    %COST_OF_TRANSPORT_P Compute cost of tranport of a step using power and average
    %walking velocity
    % x = system trajectories [pos;vel]' vector
    % tau = external forces and torques vector
    % t = time vector
    % mtotal = total biped mass
    % g = gravitational acceleration constant
    % d = COM travel distance over a step
    % from https://en.wikipedia.org/wiki/Cost_of_transport
    n = min(size(x))/2;
    %using absolute values for force and velocity, basically assuming no
    %regeneration
    E = trapz(dot(abs(x(:,n+1:end)),abs(tau),2),t);
    COT = E/(mtotal*g*d);
end

