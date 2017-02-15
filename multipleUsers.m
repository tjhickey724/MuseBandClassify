%{
Comparing multiple users bandspace maps
%}

A = importdata('Data/Ziyu_020817.txt',' ',0);
B = importdata('Data/Zheng_020317_47E2.txt',' ',0);
C = importdata('Data/Yanan_020517.txt',' ',0);
D = importdata('Data/Qinyao_020517.txt',' ',0);
E = importdata('Data/Mercedes_020817_5EAE.txt',' ',0);

i0= 6000

i1=9000;
A = A(:,2:21);
B = B(:,2:21);
C = C(:,2:21);
D = D(:,2:21);
E = E(:,2:21);

nA = length(A);
nB = length(B);
nC = length(C);
nD = length(D);
nE = length(E);

bAB = nA
bBC = nA+nB;
bCD = nA+nB+nC
bDE = nA+nB+nC+nD
bE = bDE+nE



all = [A;B;C;D;E];
ind = 1:length(all);
beE = length(all);

%[coeff,score,latent,tsquared,explained,mu] = pca(all);
[coeff,score,latent,tsquared,explained,mu] = pca(all);
first=4;
plot3(score(          ind<=bAB,first),score(ind<=bAB,2),score(ind<=bAB,3),'-r');
hold on;
plot3(score(bAB<ind & ind<=bBC,first),score(bAB<ind & ind<=bBC,2),score(bAB<ind & ind<=bBC,3),'-b');
plot3(score(bBC<ind & ind<=bCD,first),score(bBC<ind & ind<=bCD,2),score(bBC<ind & ind<=bCD,3),'-g');
plot3(score(bCD<ind & ind<=bDE,first),score(bCD<ind & ind<=bDE,2),score(bCD<ind & ind<=bDE,3),'-y');
plot3(score(bDE<ind & ind<=bE,first),score(bDE<ind & ind<=bE,2),score(bDE<ind & ind<=bE,3),'-c');
hold off
xlabel('p1');
ylabel('p2');
zlabel('p3');

rotate3d on
grid on
grid minor
