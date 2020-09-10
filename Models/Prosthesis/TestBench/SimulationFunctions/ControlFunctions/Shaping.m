function u = Shaping(x)
    %SHAPING Changes the closed-loop mass/inertia and geometry properties of
    %the 2 link biped.
    %   Detailed explanation goes here
    global flowdata
    
    params = flowdata.Parameters.Dynamics.asvector;
    xshift = flowdata.Parameters.Shaping.shift;
    u = G_Shape_Law_func(x,params,xshift);
    if any(isnan(u))
       warning("Shaping Control returned NaN")
    end
    u = u(:);
end

