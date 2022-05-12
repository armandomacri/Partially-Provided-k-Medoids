clear all; clc; close;

rng('default'); % For reproducibility


X = [randn(100,2)*0.75+ones(100,2);
    randn(100,2)*0.55-ones(100,2)];


k=3;
f1 = tic();
[labels, medoids] = my_k_medoids(X, k);
exc_time1 = toc(f1);



%figure;
%plot(X(:,1),X(:,2),'.');
%title('Randomly Generated Data');

f2 = tic();
[idx, C] = kmedoids(X,k);
exc_time2 = toc(f2);

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',7)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',7)
hold on;
plot(X(idx==3,1),X(idx==3,2),'k.','MarkerSize',7)

plot(C(:,1),C(:,2),'co',...
     'MarkerSize',7,'LineWidth',1.5)
legend('Cluster 1','Cluster 2','Cluster 3', 'Medoids',...
       'Location','NW');
title('Cluster Assignments and Medoids');
hold off

