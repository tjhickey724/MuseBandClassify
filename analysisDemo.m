% This produces five plots based on the number of clusters:
numClusters = 10

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
subplot(5,1,1);
musePlot(all);grid on; grid minor;
legend('alpha','beta','delta','gamma','theta');
subplot(5,1,2);
plot(C*0.2+0.5,'.b');grid on; grid minor;
subplot(5,1,3);
zz = clusterWindow(C,300);
plot(zz);
legend(string(1:max(C)));
grid on; grid minor;
subplot(5,1,4);
a1= hist(C(1:3000),0.5:numClusters+0.5);
a2= hist(C(3000:6000),0.5:numClusters+0.5);
a3= hist(C(6000:9000),0.5:numClusters+0.5);
a4= hist(C(9000:length(C)),0.5:numClusters+0.5);
aa = [a1;a2;a3;a4]';
bar(aa); legend('math','relax1','reading','relax2');

subplot(5,1,5);
bar(aa'); legend(string([1:numClusters]));

%vv = min(max(C),[1:max(C)]*(zz'==max(zz'))); % find which cluster is highest at each point
%plot(vv,'.'); % this plots the cluster which is higest in the previous plot
%legend(string(1:max(C)));


% look into analyzing data using pca(all) to see which
% vectors have the most importance, and cluster on those??

