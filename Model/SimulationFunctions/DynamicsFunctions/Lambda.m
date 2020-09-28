function lambda_vec = Lambda(t,y)
    %LAMBDA Calculates constraint forces. 
    %   Detailed explanation goes here
    global flowdata

    dim = flowdata.Parameters.dim;
    params = flowdata.Parameters.Biped.asvec;
    
    x = y(1,:)';
    q = x(1:dim/2);         %position
    qdot = x(dim/2+1:dim);  %velocity
    [A,~] = flowdata.getConstraintMtxs(q,qdot);
    lambda_vec = zeros(length(t),rank(A));
    
    for j=1:length(t)
        x = y(j,:)';
        q = x(1:dim/2);         %position
        qdot = x(dim/2+1:dim);  %velocity

        %Contact constraints 
        [A,Adot] = flowdata.getConstraintMtxs(q,qdot);

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
        end

        ue = zeros(dim/2,1);
        for i = 1:length(flowdata.Controls.External)
            u_ext = flowdata.Controls.External{i}(t,x,ui);
            u_array(i+length(flowdata.Controls.Internal),:,:) = u_ext';
            ue = ue + u_ext;
        end          

        u = ui+ue;
        %Constraint Multipliers and Joint Accelerations
        if (rank(A) == min(size(A))) && (rank(A)<dim/2) && ~isempty(A)
            lambda = ((A/M)*A')\((A/M)*(u  - C*qdot - G) + Adot*qdot);
        elseif isempty(A)
            lambda = 0;
        else
            lambda = zeros(min(size(A)),1);
        end 
        lambda_vec(j,:) = lambda';
    end   
end

