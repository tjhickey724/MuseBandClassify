
% This produces five plots based on the number of clusters:
numClusters = 24;

windowSize = 600;

f1 = figure(1);

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
all = importdata('57_3.txt',' ',0);
all = all(500:length(all),:);
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

%a1= hist(C(1:3000),0.5:numClusters-0.5);
%a2= hist(C(3000:6000),0.5:numClusters-0.5);
%a3= hist(C(6000:9000),0.5:numClusters-0.5);
%a4= hist(C(9000:length(C)),0.5:numClusters-0.5);

a1= hist(C(600:2400),0.5:numClusters-0.5);
a2= hist(C(3600:5400),0.5:numClusters-0.5);
a3= hist(C(6600:8400),0.5:numClusters-0.5);
a4= hist(C(9600:11400),0.5:numClusters-0.5);

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
%legend(string(1:max(CC)));
legend('math','relax1','reading','relax2');
grid on; grid minor;
xticks([0:3000:12000])
% look into analyzing data using pca(all) to see which
% vectors have the most importance, and cluster on those??
clusters = [1:numClusters];
mathClusters = clusters(vv(1,:)==1);
closedClusters = clusters(vv(2,:)==1);
readClusters = clusters(vv(3,:)==1);
openClusters = clusters(vv(4,:)==1);
title('Plot D: 1 minute smoothing of k-means classification');



% Next we plot the Markov model of all cluster nodes
% if control passes from one to the other more than Cutoff times
% we draw an edge between them
% Cutoff=5
%{
B=zeros(numClusters,numClusters);
for i=[1:length(C)-1]
  B(C(i),C(i+1)) = B(C(i),C(i+1))+1;
end


f2 = figure(2);
coords= [aa(:,1)-0.7*aa(:,3),aa(:,2)-0.7*aa(:,3)];

Cutoff = 0;
drawMM(aa,B,Cutoff);

%}

%{
BB = B-min(B,Cutoff)+Cutoff
BB(BB==Cutoff) = 0
gplot(BB,coords)
title('Markov Model of Cluster Points')
%}

%{
% create a symmetric version of the digraph
B2 = B+B';
BB = B2-min(B2,Cutoff)+Cutoff;
BB(BB==Cutoff) = 0;
BB = BB - BB.*eye(size(BB)); % remove diagonal
% use it to create a graph object
G = graph(BB);

% scale the line widths
LWidths = 5*G.Edges.Weight/max(G.Edges.Weight);

% plot the graph
h = plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths)
bb = (aa'./sum(aa'))';
nodecolor=bb(:,1:3);
nodecolor(:,3) = bb(:,1);  % blue for math
nodecolor(:,2) = bb(:,3);  % green for reading
nodecolor(:,1) = bb(:,4);  % red for ClosedEye
nodecolor = (nodecolor'./sum(bb'))';
h.NodeColor = nodecolor;
h.MarkerSize = sum(aa')./(max(max(aa))/20);
h.NodeLabel = sum(aa')

%}
colors = ['b','r','g','y'];
figure(3)

[coeff,score,latent,tsquared,explained,mu] = pca(all);

%{
for k = [1,2,3,4]
    theColor = string('-*')+string(colors(k));
    
    plot3(score(CC==k,1),score(CC==k,2),score(CC==k,3),theColor); hold on;
end
%}
k=1; plot3(score(CC==k,1),score(CC==k,2),score(CC==k,3),'-*b'); hold on;
k=2; plot3(score(CC==k,1),score(CC==k,2),score(CC==k,3),'-*r'); hold on;
k=3; plot3(score(CC==k,1),score(CC==k,2),score(CC==k,3),'-*g'); hold on;
k=4; plot3(score(CC==k,1),score(CC==k,2),score(CC==k,3),'-*y'); hold on;
hold off
legend('math','openeye','reading','closedeye')
title('PCA plots of four k-mean classifications')
xlabel('pca1')
ylabel('pca2')
zlabel('pca3')
grid on
grid minor
rotate3d on

figure(6)

indx = 1:length(C);
indM = indx<3000;
indC = indx>=3000& indx<6000;
indR = indx>=6000 & indx<9000;
indO = indx>=9000;
ind=[indM;indC;indR;indO];
plot3(score(indM,1),score(indM,2),score(indM,3),'-*b'); hold on;
plot3(score(indC,1),score(indC,2),score(indC,3),'-*r'); hold on;
plot3(score(indR,1),score(indR,2),score(indR,3),'-*g'); hold on;
plot3(score(indO,1),score(indO,2),score(indO,3),'-*y'); hold on;
hold off
legend('math','openeye','reading','closedeye')
title('PCA plots of four activities')
xlabel('pca1')
ylabel('pca2')
zlabel('pca3')
grid on
grid minor
rotate3d on
%{
figure(4)
for k=[1:4]
    subplot(3,2,k);scatter(score(CC==k,1),score(CC==k,2),colors(k)); 
    grid on; grid minor; axis([-1,1,-1,1]);title(string('predicted')+string(k));
end

subplot(3,2,5);
for k=[1:4]
    scatter(score(CC==k,1),score(CC==k,2),colors(k)); hold on;
    grid on; grid minor; axis([-1,1,-1,1]);
end
title('PCA 1,2 projection of Predicted Activities')
subplot(3,2,6);
for k=[1:4]
    scatter(score(CC==k,1),score(CC==k,3),colors(k)); hold on;
    grid on; grid minor; axis([-1,1,-1,1]);
end
title('PCA 1,3 projection of Predicted Activities')
hold off

figure(5)
subplot(3,2,1)
scatter(score(1:3000,1),score(1:3000,2),'b');
axis([-1,1,-1,1]);title('Actual Math');grid on; grid minor;
subplot(3,2,2)
scatter(score(3000:6000,1),score(3000:6000,2),'r');
axis([-1,1,-1,1]);title('Actual Open Eye Relaxation');grid on; grid minor;
subplot(3,2,3)
scatter(score(6000:9000,1),score(6000:9000,2),'g');
axis([-1,1,-1,1]);title('Actual Reading');grid on; grid minor;
subplot(3,2,4)
scatter(score(9000:length(C),1),score(9000:length(C),2),'y');
axis([-1,1,-1,1]);title('Actual ClosedEye Relaxation');grid on; grid minor;
subplot(3,2,5)
step=1;
scatter(score(1:step:3000,1),score(1:step:3000,2),colors(1));hold on
scatter(score(3000:step:6000,1),score(3000:step:6000,2),colors(2));
scatter(score(6000:step:9000,1),score(6000:step:9000,2),colors(3));
scatter(score(9000:step:length(C),1),score(9000:step:length(C),2),colors(4));hold off
grid on; grid minor; axis([-1,1,-1,1]);
title('PCA 1,2 projection of Predicted Activities');
subplot(3,2,6)
scatter(score(1:step:3000,1),score(1:step:3000,3),colors(1));hold on
%scatter(score(3000:step:6000,1),score(3000:step:6000,3),colors(2));
scatter(score(6000:step:9000,1),score(6000:step:9000,3),colors(3));
%scatter(score(9000:step:length(C),1),score(9000:step:length(C),3),colors(4));hold off
grid on; grid minor; axis([-1,1,-1,1]);
title('PCA 1,3 projection of Predicted Activities')
hold off
%}


figure(7);
ZZ = zeros(100,20);
ZZ2 = zeros(0,20);
data=ZZ;
for k=[1:max(C)]
    data = [data;all(C==k,:);ZZ];
end
musePlot(data);

figure(8);
data=ZZ;
index = [1:length(all)]
for k=mathClusters
    data = [data;all(C==k,:);ZZ];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
for k=closedClusters
    data = [data;all(C==k,:);ZZ];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
for k=readClusters
    data = [data;all(C==k,:);ZZ];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
data1 = []
for k=openClusters
    data1 = [data1;all(C==k,:);ZZ];
end
length(data1)
data = [data;data1];
musePlot(data);
axis([0,12000,0,4]);


figure(17);
data=ZZ;
index = [1:length(all)]
for k=mathClusters
    data = [data;all(C==k&index<3000,:);ZZ2];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
for k=closedClusters
    data = [data;all(C==k&3000<index& index<6000,:);ZZ2];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
for k=readClusters
    data = [data;all(C==k&6000<index&index<9000,:);ZZ2];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
data1 = []
for k=openClusters
    data1 = [data1;all(C==k&9000<index,:);ZZ2];
end
length(data1)
data = [data;data1];
musePlot(data);
axis([0,12000,0,4]);


figure(18);
data=ZZ;
index = [1:length(all)]
for k=[closedClusters,readClusters,openClusters]
    data = [data;all((C==k)& (index<3000),:);ZZ2];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
for k=[mathClusters,readClusters,openClusters]
    data = [data;all((C==k)& (3000<index&index<6000),:);ZZ2];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
for k=[mathClusters,closedClusters,openClusters]
    data = [data;all((C==k)& (6000<index&index<9000),:);ZZ2];
end
data = [data;ZZ;ZZ;ZZ;ZZ];
data2=[]
for k=[mathClusters,closedClusters,readClusters]
    data2 = [data2;all((C==k)& (9000<index),:);ZZ2];
end
length(data2)
data = [data;data2];
musePlot(data);
axis([0,12000,0,4]);

