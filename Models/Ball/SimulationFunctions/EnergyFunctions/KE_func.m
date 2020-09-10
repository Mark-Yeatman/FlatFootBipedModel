function ke = KE_func(x)
    global flowdata
    m = flowdata.Parameters.Biped('m');   
    ke=(1/2).*m.*(x(3).^2+x(4).^2);
end
