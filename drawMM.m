function [h G] = drawMM(aa, B, Cutoff )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
f2 = figure(2);
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
h = plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths);
bb = (aa'./sum(aa'))';
nodecolor=bb(:,1:3);
nodecolor(:,3) = bb(:,1);  % blue for math
nodecolor(:,2) = bb(:,3);  % green for reading
nodecolor(:,1) = bb(:,4)+bb(:,2);  % red for Relaxed
nodecolor = (nodecolor'./sum(bb'))';
h.NodeColor = nodecolor;
h.MarkerSize = sum(aa')./(max(max(aa))/20);
h.NodeLabel = sum(aa');
title('Markov Model of Cluster Nodes')
end

