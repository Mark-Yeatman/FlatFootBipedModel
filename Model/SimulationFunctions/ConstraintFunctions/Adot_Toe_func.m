function Adot = Adot_Toe_func(q,qdot)
global flowdata
    lf = flowdata.Parameters.Biped.lf;
    x = [q;qdot];
    Adot = [[0,0,(-1).*lf.*cos(x(3)).*x(11),0,0,0,0,0];[0,0,(-1).*lf.*sin(x(3)).*x(11),0,0,0,0,0]];   
end

