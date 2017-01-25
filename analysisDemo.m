% read in the data
all = importdata('bands.txt',' ',0);
all = all(:,2:21); % throw out the first parameter which is the time in seconds
% select a section of 1000 observations from each
musePlot(all);  % look at all data, select some

% classify 
[idx,X,sumd,D] = kmeans(all,6);

[C,D]=museClassifyAll(all,1,X);

% plot
hold off;
subplot(4,1,1);
musePlot(all);grid on; grid minor;
legend('alpha','beta','delta','gamma','theta');
subplot(4,1,2);
plot(C*0.2+3.55,'.b');grid on; grid minor;
subplot(4,1,3);
zz = clusterWindow(C,300);
plot(zz);
legend(string(1:max(C)));
grid on; grid minor;
subplot(4,1,4);
vv = min(max(C),[1:max(C)]*(zz'==max(zz'))); % find which cluster is highest at each point
plot(vv,'.'); % this plots the cluster which is higest in the previous plot
%legend(string(1:max(C)));



