function [done]= musePlot(data)
s=1;t=0;
    plot(t+data(:,s+0),'-r'); hold on; 
    plot(t+data(:,s+4),'-b'); 
    plot(t+data(:,s+8),'-c'); 
    plot(t+data(:,s+12),'-m'); 
    plot(t+data(:,s+16),'-g');

s=2;t=1;
    plot(t+data(:,s+0),'-r'); hold on; 
    plot(t+data(:,s+4),'-b'); 
    plot(t+data(:,s+8),'-c'); 
    plot(t+data(:,s+12),'-m'); 
    plot(t+data(:,s+16),'-g');

s=3;t=2;
    plot(t+data(:,s+0),'-r'); hold on; 
    plot(t+data(:,s+4),'-b'); 
    plot(t+data(:,s+8),'-c'); 
    plot(t+data(:,s+12),'-m'); 
    plot(t+data(:,s+16),'-g');

s=4;t=3;
    plot(t+data(:,s+0),'-r'); hold on; 
    plot(t+data(:,s+4),'-b'); 
    plot(t+data(:,s+8),'-c'); 
    plot(t+data(:,s+12),'-m'); 
    plot(t+data(:,s+16),'-g');

hold off;
done = 1.0;
end
