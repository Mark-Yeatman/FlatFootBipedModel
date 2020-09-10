grad = 0;
t_before =0;
L = length(t_impacts)-1;

hold on;
for i=1:L
    derp = t_impacts{i}; 
    t_end = derp(end) + t_before;
    ti_array = tout< t_end & tout>t_before;
    %disp(strcat(num2str(t_before),',',num2str(t_end)))
    c = [0	255	255]/255;
    p = [75,0,130]/255;
    c2p = c+grad*(p-c);
    y = [255	219	0]/255;
    r = [139, 0, 0]/255;
    blue =[0 0.447 0.741];
    orange = [0.8500 0.3250 0.0980];
    y2r = y+grad*(r-y);
    %l1 = plot(-1*(xout(ti_array,3)+xout(ti_array,4) + xout(ti_array,5)),-1*(xout(ti_array,3+8)+xout(ti_array,4+8) + xout(ti_array,5+8)),'Color',p); %psuedo ankle angle phase portrait
    l1 = plot(-1*(-xout(ti_array,3)-xout(ti_array,4) - xout(ti_array,5) + xout(ti_array,6) + xout(ti_array,7) + xout(ti_array,8) ),...
         -1*(-xout(ti_array,3+8)-xout(ti_array,4+8) - xout(ti_array,5+8) + xout(ti_array,6+8)+xout(ti_array,7+8) + xout(ti_array,8+8)),'Color',orange); %psuedo hip-ankle angles phase portrait
    grad = grad + 1/L;
    t_before = t_end;
end
xlabel('$\theta$ (rad)','Interpreter','latex')
ylabel('$\frac{d\theta}{dt}$ rad/s','Interpreter','latex')
legend([l1,l2],'\theta_{1}','\theta_{2}','Interpreter','latex')
