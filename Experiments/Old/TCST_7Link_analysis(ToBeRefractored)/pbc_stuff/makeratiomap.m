ratiospace = [0,0.1,0.2,0.3,0.4,0.6,0.7,0.8,0.9];
m = 5*length(ratiospace);
ratiomap1 = zeros(m,8);
ratios = [0,0,0,1,1,1,1,1];
for j=8:-1:4% grid joints
    for k=length(ratiospace):-1:1 %grid gains
        ratios(j) = ratiospace(k);
        ratiomap1(m,:) = ratios;
        m = m-1;
    end
end

ratiomap2 = zeros(m,8);
ratios = [0,0,0,1,1,1,1,1];
m = 5*length(ratiospace);
for j=4:8% grid joints
    for k=length(ratiospace):-1:1 %grid gains
        ratios(j) = ratiospace(k);
        ratiomap2(m,:) = ratios;
        m = m-1;
    end
end