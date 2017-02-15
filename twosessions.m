% two sessions, use first as predictor for second

numClusters = 12;

windowSize = 600;



bands1 = importdata('bands1.txt',' ',0);
%bands1 = bands1(0:length(bands1),:); 
bands1= bands1(:,2:21); % throw out the first parameter which is the time in seconds
% select a section of 1000 observations from each


bands2 = importdata('bands2.txt',' ',0);
%bands2 = bands2(0:length(bands2),:); 
bands2= bands2(:,2:21); % throw out the first parameter which is the time in seconds

f1 = figure(1);
subplot(2,1,1);
musePlot(bands1);  % look at all data, select some
subplot(2,1,2);
musePlot(bands2);  % look at all data, select some




[idx,X,sumd,D] = kmeans(bands1,numClusters);

[C1,D1]=museClassifyAll(bands1,1,X);
[C2,D2]=museClassifyAll(bands2,1,X);


figure(2)
subplot(2,1,1); 
C=C1;
a1= hist(C(1:3000),0.5:numClusters-0.5);
a2= hist(C(3000:6000),0.5:numClusters-0.5);
a3= hist(C(6000:9000),0.5:numClusters-0.5);
a4= hist(C(9000:length(C)),0.5:numClusters-0.5);

aa = [a1;a2;a3;a4]';
aa1 = aa;

bar(aa./30); legend('math','relax1','reading','relax2');
title('Plot B. Frequency each cluster in Session 1 appears in MORC sections')

subplot(2,1,2); 
C=C2;
a1= hist(C(1:3000),0.5:numClusters-0.5);
a2= hist(C(3000:6000),0.5:numClusters-0.5);
a3= hist(C(6000:9000),0.5:numClusters-0.5);
a4= hist(C(9000:length(C)),0.5:numClusters-0.5);

aa = [a1;a2;a3;a4]';
aa2 = aa;
bar(aa./30); legend('math','relax1','reading','relax2');
title('Plot B. Frequency each cluster in Session 2 appears in MORC sections')




figure(3)
subplot(2,1,1)
aa=aa1;
C = C1;
 vv = (aa' == max(aa'));
 numCC = 4;
 dd = [1:numCC]*vv;
 CC = dd(C);
 CC1=CC;
 c1= hist(CC(1:3000),0.5:numCC-0.5);
c2= hist(CC(3000:6000),0.5:numCC-0.5);
c3= hist(CC(6000:9000),0.5:numCC-0.5);
c4= hist(CC(9000:length(CC)),0.5:numCC-0.5);
ccs = [c1;c2;c3;c4]'./30;
bar(ccs'); legend('math','relax1','reading','relax2');
grid on;
grid minor;
axis([0,5,0,100])
title('Plot C: Accuracy of k-means classification for each MORC region')


subplot(2,1,2)
aa=aa2;
C = C2;
 %vv = (aa' == max(aa'));
 %numCC = 4;
 %dd = [1:numCC]*vv;
 CC = dd(C);
 CC2 = CC;
 c1= hist(CC(1:3000),0.5:numCC-0.5);
c2= hist(CC(3000:6000),0.5:numCC-0.5);
c3= hist(CC(6000:9000),0.5:numCC-0.5);
c4= hist(CC(9000:length(CC)),0.5:numCC-0.5);
ccs = [c1;c2;c3;c4]'./30;
bar(ccs'); legend('math','relax1','reading','relax2');
grid on;
grid minor;
axis([0,5,0,100])
title('Plot C: Accuracy of k-means classification for each MORC region')




figure(4)
subplot(2,1,1);
CC=CC1;
zz1 = clusterWindow(CC,windowSize);
plot(zz1./(windowSize/100));
%legend(string(1:max(CC)));
legend('math','relax1','reading','relax2');
grid on; grid minor;
xticks([0:3000:12000])
% look into analyzing data using pca(all) to see which
% vectors have the most importance, and cluster on those??

subplot(2,1,2);
CC=CC2;
zz1 = clusterWindow(CC,windowSize);
plot(zz1./(windowSize/100));
%legend(string(1:max(CC)));
legend('math','relax1','reading','relax2');
grid on; grid minor;
xticks([0:3000:12000])
% look into analyzing data using pca(all) to see which
% vectors have the most importance, and cluster on those??


title('Plot D: 1 minute smoothing of k-means classification');
