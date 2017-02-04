% This produces five plots based on the number of clusters:
numClusters = 24

windowSize = 600

figure

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
all = importdata('bands.txt',' ',0);
all = all(:,2:21); % throw out the first parameter which is the time in seconds
% select a section of 1000 observations from each
musePlot(all);  % look at all data, select some


% classify 

[idx,X,sumd,D] = kmeans(all,numClusters);

[C,D]=museClassifyAll(all,1,X);

% plot
hold off;

numg = 4;
pos = 1;

subplot(numg,1,pos); pos=pos+1;
musePlot(all);
xticks([0:3000:12000])
grid on; grid minor;
legend('alpha','beta','delta','gamma','theta');


%{
subplot(numg,1,pos); pos=pos+1;
plot(C*0.2+0.5,'.b');grid on; grid minor;

subplot(numg,1,pos); pos=pos+1;
zz = clusterWindow(C,windowSize);
plot(zz);
legend(string(1:max(C)));
grid on; grid minor;
%}


%Ctemp = [C(1:4:length(C)), C(2:4:length(C)),C(3:4:length(C)),C(4:4:length(C))];
%C = Ctemp;
%Ctemp2 = C(randperm(length(C)));
%C=Ctemp2;
subplot(numg,1,pos); pos=pos+1;

a1= hist(C(1:3000),0.5:numClusters-0.5);
a2= hist(C(3000:6000),0.5:numClusters-0.5);
a3= hist(C(6000:9000),0.5:numClusters-0.5);
a4= hist(C(9000:length(C)),0.5:numClusters-0.5);

aa = [a1;a2;a3;a4]';
bar(aa./30); legend('math','relax1','reading','relax2');
title('Plot B. Frequency each cluster appears in MORC sections')


%{
subplot(numg,1,pos); pos=pos+1;
bar(aa'); legend(string([1:numClusters]));
%}

%vv = min(max(C),[1:max(C)]*(zz'==max(zz'))); % find which cluster is highest at each point
%plot(vv,'.'); % this plots the cluster which is higest in the previous plot
%legend(string(1:max(C)));
subplot(numg,1,pos); pos=pos+1;

 vv = (aa' == max(aa'));
 numCC = 4;
 dd = [1:numCC]*vv;
 CC = dd(C);
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




subplot(numg,1,pos); pos=pos+1;
zz1 = clusterWindow(CC,windowSize);
plot(zz1./(windowSize/100));
legend(string(1:max(CC)));
grid on; grid minor;
xticks([0:3000:12000])
% look into analyzing data using pca(all) to see which
% vectors have the most importance, and cluster on those??
clusters = [1:numClusters]
mathClusters = clusters(vv(1,:)==1)
openClusters = clusters(vv(2,:)==1)
readClusters = clusters(vv(3,:)==1)
closedClusters = clusters(vv(4,:)==1)
title('Plot D: 1 minute smoothing of k-means classification')



% Next we plot the Markov model of all cluster nodes
% if control passes from one to the other more than Cutoff times
% we draw an edge between them
Cutoff=5
B=zeros(numClusters,numClusters);
for i=[1:length(C)-1]
  B(C(i),C(i+1)) = B(C(i),C(i+1))+1;
end
figure
coords= [aa(:,1)-0.7*aa(:,3),aa(:,2)-0.7*aa(:,3)];

C = B-min(B,Cutoff)+Cutoff
C(C==Cutoff) = 0
gplot(C,coords)
title('Markov Model of Cluster Points')