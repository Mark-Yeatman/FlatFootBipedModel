function Adot = Adot_Toe_func(q,qdot)
global flowdata
    lf = flowdata.Parameters.Biped.lf;

    Adot=zeros(2,8);       
    Adot(1,3)=lf*cos(q(3))*qdot(3);
    Adot(2,3)=lf*sin(q(3))*qdot(3);    
end

