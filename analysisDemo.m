% read in the data
all = importdata('bands.txt',' ',0);
all = all(:,2:21); % throw out the first parameter which is the time in seconds
% select a section of 1000 observations from each
musePlot(all);  % look at all data, select some

% classify 
[idx,X,sumd,D] = kmeans(all,10);

[C,D]=museClassifyAll(all,1,X);

% plot
hold off;
subplot(3,1,1);
musePlot(all);grid on; grid minor;
subplot(3,1,2);
plot(C*0.2+3.55,'.b');grid on; grid minor;
subplot(3,1,3);
zz = clusterWindow(C,600);
plot(zz);
legend(string(1:max(C)));
grid on; grid minor;



