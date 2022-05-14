clear all; clc; close;

rng('default'); % For reproducibility
X = [randn(100,2)*0.75+ones(100,2);
    randn(100,2)*0.55-ones(100,2)];


k=4;
f1 = tic();
[labels, medoids, v] = optimized_k_medoids(X, k);
exc_time1 = toc(f1);


f2 = tic();
[labels2, medoids2, v2] = partially_provided_k_medoids(X, k, [14; 178]);
exc_time2 = toc(f2);



%figure;
%plot(X(:,1),X(:,2),'.');
%title('Randomly Generated Data');

%{
f3 = tic();
[idx, C, energy] = kmedoids(X,k);
exc_time3 = toc(f3);
idx=idx';


figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',7)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',7)
hold on;
plot(X(idx==3,1),X(idx==3,2),'k.','MarkerSize',7)

for j=1:k
    plot(X(C(j),1), X(C(j),2),'co','MarkerSize',7,'LineWidth',1.5)
end
legend('Cluster 1','Cluster 2','Cluster 3', 'Location','NW');

title('Cluster Assignments and Medoids');
hold off
%}
