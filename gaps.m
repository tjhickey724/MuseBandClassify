function [ g ] = gaps(jdist,cutoff )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
g = zeros(1,10000);
start=1;
for pos=[1:length(jdist)]
    if (jdist(pos)>cutoff)
        d = pos-start;
        g(d+1) = g(d+1)+1;
        start = pos+1;
    end

end

