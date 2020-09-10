ti_array = tout < t_impacts{1}(3);
plot(-1*(xout(ti_array,3)+xout(ti_array,4) + xout(ti_array,5)),-1*(xout(ti_array,3+8)+xout(ti_array,4+8) + xout(ti_array,5+8))) %psuedo ankle angle phase portrait
hold on
plot(-1*(-xout(ti_array,3)-xout(ti_array,4) - xout(ti_array,5) + xout(ti_array,6) + xout(ti_array,7) + xout(ti_array,8) ),-1*(-xout(ti_array,3+8)-xout(ti_array,4+8) - xout(ti_array,5+8) + xout(ti_array,6+8)+xout(ti_array,7+8) + xout(ti_array,8+8))) %psuedo hip-ankle angles phase portrait
legend('theta_1','theta_2')
