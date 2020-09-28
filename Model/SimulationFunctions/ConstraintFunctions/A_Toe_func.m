function A = A_Toe_func(q,qdot)
global flowdata
    lf = flowdata.Parameters.Biped.lf;
    x = [q;qdot];
    A = [[1,0,(-1).*lf.*sin(x(3)),0,0,0,0,0];[0,1,lf.*cos(x(3)),0,0,0,0,0]];
end

