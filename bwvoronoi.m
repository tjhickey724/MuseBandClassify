% This generates the Voronoi cells for the cluster points
% Variables to change, could be args to a function later
filename = '55_4.txt';
numClusters = 12;

% first we read in the data
all = importdata('55_4.txt',' ',0);
all = all(:,2:21);

% then we do a k-mean clustering
[idx,X,sumd,D] = kmeans(all,numClusters);

% then we do a PCA projection
[coeff,score,latent,tsquared,explained,mu] = pca(all);

% then we project the cluster points X into PCA space
 X1 = (X - repmat(mu,12,1))/coeff';
 
% then we project X1 into 3D space
X3d =X1(:,1:3);

% then we add the vertices of a threshold cube to X3d so that
% the voronoi cells are all bounded (i.e. no infinite values)
Cube = [
    1 1 1;
    1 1 -1;
    1 -1 1;
    1 -1 -1;
    -1 1 1;
    -1 1 -1;
    -1 -1 1;
    -1 -1 -1];

% then we call voronoin to get the voronoic cells for each of the k+8
% vertices here. Tbe cube vertice will all have at least one infinite
% vertex, i.e. they are all unbounded, but we don't care
[V,C] = voronoin([X3d;2*Cube],{'Qbb'});

% then we calculate the convex hull of one these voronoi cells
v = 2;  % say the first voronic cell

[K1,V1] = convhulln(V(C{v}',:),{'Qt'});

% this draws the outline of all of the finite Voronoi cells
% we are making progress...

shp = alphaShape(V(2:67,:));
plot(shp);

% this shows the volume of each of the voronoi cells...

for i = [1:20]
display(i)
try
shp = alphaShape(V(C{i}',:));
display(volume(shp))
end
end