function length = StepLength(t,y,~)
    %GETSTEPLENGTH Measures step length of the 7link biped using COM position at step start and finish. 
    %   
    global flowdata
    params = flowdata.Parameters.Biped.asvec;
    xstart = y(1,:);
    xend = y(end,:);
    temp1 = COM_pos_func(xstart',params);
    temp2 = COM_pos_func(xend',params);
    length = norm(temp2-temp1);
end

