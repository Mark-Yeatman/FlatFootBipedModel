function length = getStepLength(xstart,xend)
    %GETSTEPLENGTH Measures step length of the 7link biped using COM position at step start and finish. 
    %   
    temp1 = COM_pos_func(xstart');
    temp2 = COM_pos_func(xend');
    length = norm(temp2-temp1);
end

