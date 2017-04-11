function [ jdist ] = findJumps(bands )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
N = length(bands);
bands1 = bands(1:N-1,:);
bands2 = bands(2:N,:); 
jdist=distN(bands1,bands2);

end

