function [all, aa, ccs, zz1, score  ] = overviewMultiple(filenames,numClusters )
%overview Show main clustering data for the specified file
%   this calls museplot on all 4 electrodes
%   shows the clusters and their specificity for each of the activities
%   show the 4 meta-clusters and their specificity
%   shows the accuracy of prediction over all the data

% example:
% files = {'55_1.txt',  '55_2.txt',  '55_3.txt',  '55_4.txt',  '55_5.txt',
% '56_1.txt',  '56_2.txt',  '56_3.txt',  '56_4.txt',  '56_5.txt', 
%'57_1.txt',  '57_2.txt',  '57_3.txt',  '57_4.txt',  '58_1.txt', 
%'58_2.txt', '58_3.txt',  '59_1.txt',  '59_2.txt',  '59_3.txt'}

windowSize = 600;

% The top plot is the five bands for each of the 4 electrodes

% The second plot is the clusters for each sample

% The third plot is the percentage of a sliding window containing each
% cluster

% The fourth is the number of times that each cluster appears in each of
% the four mental activities, arranged by cluster 

% The fifth is the same number of times that each cluster appears but
% arranged by activity


% Here is the code ..
% read in the data
math=[]
read=[];
shut=[];
open=[];
numFiles = length(filenames);

for i=[1:numFiles]  
    filename = filenames{i}
    all = importdata(filename,' ',0);
    extra = max(1,round((length(all)-12000)/2))
    all = all(extra:length(all)-extra,:);
    all = all(:,2:21);
    sizes = [size(math);size(shut);size(read);size(open)]
    math = [math;all(1:3000,:)];
    shut = [shut;all(3001:6000,:)];
    read = [read;all(6001:9000,:)];
    open = [open;all(9001:length(all),:)];
end
    
all = [math;shut;read]; %open];

%musePlot(all);  % look at all data, select some


% classify 

[idx,X,sumd,D] = kmeans(all,numClusters);

[C,D]=museClassifyAll(all,1,X);

% plot
hold off;

figure(1);

subplot(4,1,1); 
musePlot(all);
%xticks([0:3000:12000])
grid on; grid minor;
legend('alpha','beta','delta','gamma','theta');



subplot(4,1,2); 
% plot of the frequency each cluster appears in each core activity
% i.e. the middle three minutes of each activity
mathMax = 3000*numFiles;
shutMax = 6000*numFiles;
readMax = length(all); %9000*numFiles;
openMax = length(all);

a1= hist(C(1:mathMax),0.5:numClusters-0.5);
a2= hist(C(mathMax+1:shutMax),0.5:numClusters-0.5);
a3= hist(C(shutMax+1:readMax),0.5:numClusters-0.5);
%a4= hist(C(readMax+1:openMax),0.5:numClusters-0.5);

aa = [a1;a2;a3]';
bar(aa./30); legend('math','relax1','reading');
title('Plot B. Frequency each cluster appears in MORC sections')




subplot(4,1,3);
% plot the accuracy of each prediction over all four activities

 vv = (aa' == max(aa'));
 numCC = 3;
 dd = [1:numCC]*vv;
 CC = dd(C);
 c1= hist(CC(1:mathMax),0.5:numCC-0.5);
 c2= hist(CC(mathMax:shutMax),0.5:numCC-0.5);
 c3= hist(CC(shutMax:readMax),0.5:numCC-0.5);
 %c4= hist(CC(readMax:openMax),0.5:numCC-0.5);
 ccs = [c1;c2;c3]'./30;
 bar(ccs'); legend('math','relax1','reading');
 grid on;
 grid minor;
 %axis([0,5,0,100])
 title('Plot C: Accuracy of k-means classification for each MORC region')




subplot(4,1,4); 
zz1 = clusterWindow(CC,windowSize);
plot(zz1./(windowSize/100));
%legend(string(1:max(CC)));
legend('math','relax1','reading');
grid on; grid minor;
%xticks([0:3000:12000])
% look into analyzing data using pca(all) to see which
% vectors have the most importance, and cluster on those??
clusters = [1:numClusters];
mathClusters = clusters(vv(1,:)==1);
closedClusters = clusters(vv(2,:)==1);
readClusters = clusters(vv(3,:)==1);
%openClusters = clusters(vv(4,:)==1);
title('Plot D: 1 minute smoothing of k-means classification');


maxzz1 = max(zz1')';
winner = (zz1==maxzz1)*[1;2;3];
n = length(math);
accuracyMath = sum(winner(1:n)==1)*100/n
accuracyShut = sum(winner(n+1:2*n)==2)*100/n
accuracyRead = sum(winner(2*n+1:3*n)==3)*100/n

figure(2)
[coeff,score,latent,tsquared,explained,mu] = pca(all);
randvec = (rand(180000,1)<0.05);
CC = CC(randvec);
k=1; plot3(score(CC==k,1),score(CC==k,2),score(CC==k,3),'-*b'); hold on;
k=2; plot3(score(CC==k,1)+1,score(CC==k,2)+1,score(CC==k,3)+1,'-*r'); hold on;
k=3; plot3(score(CC==k,1)+2,score(CC==k,2)+2,score(CC==k,3)+2,'-*g'); hold on;
hold off
legend('math','shut','read')
title('PCA plots of three k-mean classifications')
xlabel('pca1')
ylabel('pca2')
zlabel('pca3')
grid on
grid minor
rotate3d on



end

