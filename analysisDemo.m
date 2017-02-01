% This produces five plots based on the number of clusters:
numClusters = 16

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
musePlot(all);grid on; grid minor;
legend('alpha','beta','delta','gamma','theta');

%{
subplot(numg,1,pos); pos=pos+1;
plot(C*0.2+0.5,'.b');grid on; grid minor;

subplot(numg,1,pos); pos=pos+1;
zz = clusterWindow(C,300);
plot(zz);
legend(string(1:max(C)));
grid on; grid minor;
%}

subplot(numg,1,pos); pos=pos+1;
a1= hist(C(1:3000),0.5:numClusters-0.5);
a2= hist(C(3000:6000),0.5:numClusters-0.5);
a3= hist(C(6000:9000),0.5:numClusters-0.5);
a4= hist(C(9000:length(C)),0.5:numClusters-0.5);
aa = [a1;a2;a3;a4]';
bar(aa); legend('math','relax1','reading','relax2');
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


subplot(numg,1,pos); pos=pos+1;
zz1 = clusterWindow(CC,300);
plot(zz1);
legend(string(1:max(CC)));
grid on; grid minor;
% look into analyzing data using pca(all) to see which
% vectors have the most importance, and cluster on those??
clusters = [1:numClusters]
mathClusters = clusters(vv(1,:)==1)
openClusters = clusters(vv(2,:)==1)
readClusters = clusters(vv(3,:)==1)
closedClusters = clusters(vv(4,:)==1)


