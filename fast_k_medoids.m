close all; clear; 

rng('default'); % For reproducibility
X = [randn(100,2)*0.75+ones(100,2);
    randn(100,2)*0.55-ones(100,2)];
figure;
plot(X(:,1),X(:,2),'.');
title('Randomly Generated Data');

k = 2;
[idx, C] = kmedoids(X,k);

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',7)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',7)
plot(C(:,1),C(:,2),'co',...
     'MarkerSize',7,'LineWidth',1.5)
legend('Cluster 1','Cluster 2','Medoids',...
       'Location','NW');
title('Cluster Assignments and Medoids');
hold off

%{
d = 2; 
k = 4; 
n = 10; 
[X,label] = kmeansRnd(d,k,n);
X=X';

[y, c] = kmedoids(X,k);
X=X';

plotClass(X,label); 
figure; 
plotClass(X,y);
%}