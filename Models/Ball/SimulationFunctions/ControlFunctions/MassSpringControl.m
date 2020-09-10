function u = MassSpringControl(x)
    %MASSSPRINGCONTROL Cancels gravity and adds a spring in the x direction. 
    %   Creates mass-spring system
    global flowdata
    u = zeros(flowdata.Parameters.dim/2,1);
    u(2) = -flowdata.Parameters.Spring.k*(x(2) - flowdata.Parameters.Spring.L0);
    u = u(:); %makes sure its a column vector
end

