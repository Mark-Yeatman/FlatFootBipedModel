function Adot = Adot_Toe_func(x)
global flowdata
    lf = flowdata.Parameters.Biped.lf;
    dim = flowdata.Parameters.dim;
    q = x(1:dim/2);
    qdot = x(dim/2+1:dim); 
    
    Adot=zeros(2,8);       
    Adot(1,3)=lf*cos(q(3))*qdot(3);
    Adot(2,3)=lf*sin(q(3))*qdot(3);    
end

