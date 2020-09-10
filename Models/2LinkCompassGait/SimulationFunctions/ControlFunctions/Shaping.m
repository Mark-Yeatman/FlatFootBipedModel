function u = Shaping(x)
    %SHAPING Changes the closed-loop mass/inertia and geometry properties of
    %the 2 link biped.
    %   Detailed explanation goes here
    global flowdata
    
    biped_params = cell2mat(flowdata.Parameters.Biped.values);
    shaping_params = cell2mat(flowdata.Parameters.Shaping.values);
    
    M = M_func(x,biped_params);
    C = C_func(x,biped_params);
    G = G_func(x,biped_params);
    
    Md = M_func(x,shaping_params);
    Cd = C_func(x,shaping_params);
    Gd = G_func(x,shaping_params);
       
    dim = flowdata.Parameters.dim;
    %q = x(1:dim/2);        %position
    qdot = x(dim/2+1:dim);  %velocity
    
    B = [0,0;
         0,0;
         1,0;
         0,1];
    %u  = B * ( (B'*B)\(B')*( C*qdot + G -(M/Md)*(Cd*qdot+Gd)) );
    u(3:4) = (-(M(3:4,3:4)/Md(3:4,3:4))*(Cd(3:4,3:4)*qdot(3:4) +Gd(3:4))) + C(3:4,3:4)*qdot(3:4) + G(3:4);
    u(1:2) = 0;
    if any(isnan(u))
       warning("Shaping Control returned NaN")
    end
    u = u(:);
end

