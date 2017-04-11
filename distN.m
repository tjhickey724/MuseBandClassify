function [ dist] = distN(a,b)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
c = b'-a';
d = c.^2;
dist = sqrt(sum(d))';

end

