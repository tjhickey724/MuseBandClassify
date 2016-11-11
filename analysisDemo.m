% read in the data
all = importdata('bands.txt',' ',0);
all = all(:,2:21); % throw out the first parameter which is the time in seconds
% select a section of 1000 observations from each
musePlot(all);  % look at all data, select some

% classify 
[idx,X,sumd,D] = kmeans(all,8);

[C,D]=museClassifyAll(all,1,X);

% plot
hold off;
musePlot(all);
hold on; plot(C*0.2+3.55,'.b');hold off;


