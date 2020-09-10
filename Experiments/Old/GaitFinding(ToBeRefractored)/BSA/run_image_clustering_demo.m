imj=imread('testimage.tif');
[A,B,bandnumber]=size(imj);
imjdata=double(reshape(imj,A*B,bandnumber));
data.image=imj;

data.clusternumber=5; % you can change clusternumber
dim=data.clusternumber*bandnumber;

% randomly selected values for related params. of BSA
popsize=15;

bsa('imageclustering',data,popsize,dim,1,zeros(1,dim),255*ones(1,dim),1000)
u=reshape(globalminimizer,data.clusternumber,bandnumber);
s=dist(imjdata,u');
[a,imb]=min(s,[],2);
format short g
report=tabulate(imb(:))

imb=reshape(imb,A,B);
assignin('base','cimj',imb);
imshow(imj);shg
figure,imshow(imb,[]);colormap jet, shg


