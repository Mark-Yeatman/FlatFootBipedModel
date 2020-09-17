function E = KE_func(x)
    %KE_FUNC Compute kinetic energy of biped from premade mass matrix function.
    %   Takes a column state vector as input.
global flowdata
    dim = flowdata.Parameters.dim;
    params = flowdata.Parameters.Biped.asvec;
    qdot = x(dim/2+1:dim);
    E = 1/2*qdot'*M_func(x,params)*qdot;
end

