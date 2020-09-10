m = flowdata.Parameters.Biped('m');
k = flowdata.Parameters.SLIP.k;
g = flowdata.Parameters.Environment.g;
L0 = flowdata.Parameters.SLIP.L0;

SE = zeros(size(tout));
for i=1:length(tout)
    SE(i) = 1/2*m*out_extra.L1dot(i)^2 + m*g*out_extra.L1(i) + 1/2*k*(out_extra.L1(i)-L0)^2;
end

figure('Name','Spring Axis Energy','NumberTitle','off')
plot(tout,SE)
xlabel('time')
ylabel('Energy')