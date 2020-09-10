function G = G_func(x,params)
    global flowdata
    g = params(1);
    m = params(2);
    G=[0;g.*m];
end