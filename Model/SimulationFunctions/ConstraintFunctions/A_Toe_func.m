function A = A_Toe_func(q,qdot)
global flowdata
    lf = flowdata.Parameters.Biped.lf;
    A=zeros(2,8);
    A(1,1)=1;
    A(1,3)=lf*sin(q(3));
    A(2,2)=1;
    A(2,3)=lf*cos(q(3));
end

