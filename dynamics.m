function [out] = dynamics(t, x, flag)
% Input: x = [pos; vel];
%        
global flowdata

    dim = flowdata.Parameters.dim;
    params = flowdata.Parameters.Biped.asvec;

    if any(isnan(x))
        warning('Dynamics input has some nans.')
    end
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity

    %Contact constraints 
    [A,Adot] = flowdata.getConstraintMtxs(q,qdot);

    %Dynamics Matrices
    M = M_func(x,params);
    C = C_func(x,params);
    G = G_func(x,params); 

    %Control Functions
    ui = zeros(dim/2,1);
    u_array = zeros(length(flowdata.Controls.Internal)+length(flowdata.Controls.External),1,dim/2);
    for i = 1:length(flowdata.Controls.Internal)
        temp = flowdata.Controls.Internal{i}(t,x);
        u_array(i,:,:) = temp';
        ui = ui + temp;
        if any(isnan(temp)) || any(isinf(temp))
            warning('Bad control.')
        end
    end

    ue = zeros(dim/2,1);
    for i = 1:length(flowdata.Controls.External)
        temp = flowdata.Controls.External{i}(t,x,ui);
        u_array(i+length(flowdata.Controls.Internal),:,:) = temp';
        ue = ue + temp;
        %set external Power input
        out(dim+i) = qdot' * temp;
        if any(isnan(temp)) || any(isinf(temp))
            if flowdata.Flags.warnings
                warning('Bad control.')
            end
        end
    end          
    u = ui + ue;
    %Constraint Multipliers and Joint Accelerations
    if (rank(A) == min(size(A))) && (rank(A)<dim/2) && ~isempty(A)
        lambda = ((A/M)*A')\((A/M)*(u  - C*qdot - G) + Adot*qdot);
    elseif isempty(A)
        if flowdata.Flags.warnings
            warning("Biped is a projectile.")
        end
        A = 0;
        lambda = 0;
    else
        if flowdata.Flags.warnings
            warning("Biped is possibly over constrained.")
        end
        lambda = zeros(min(size(A)),1);
    end
    accel = M\( -C*qdot -G - A'*lambda + u);

    if any(isnan(accel))
        if flowdata.Flags.warnings
            warning('Acceleration has some nans.')
        end
    end

    %set velocity, acceleration outputs
    out(1:dim/2) = qdot;
    out(dim/2+1:dim) = accel;        
    out = out';
     
end
