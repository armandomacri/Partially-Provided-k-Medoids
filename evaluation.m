clear all; clc; close;

%profile off
%profile on

rng('default'); % For reproducibility
X = [randn(10000,2)*0.75+ones(10000,2);
    randn(10000,2)*0.55-ones(10000,2)];

k=100;
%f1 = tic();
%[labels, medoids, v, D, iter1] = optimized_k_medoids(X, k);
%exc_time1 = toc(f1);

[n,d] = size(X);
iterations=zeros(5,9);
complete_exec_time=zeros(5,9);

for j = 1:10
    for i = 0:9
        n_fixed = 10*i;
        permutation = randperm(n);
        fixed_medoids = permutation(1:n_fixed);

        f2 = tic();
        [labels2, medoids2, v2, D2, iter2] = partially_provided_k_medoids(X, k, fixed_medoids');
        exc_time2 = toc(f2);
        iterations(j,i+1) = iter2;
        complete_exec_time(j,i+1)=exc_time2;   
    end
end

iter = mean(iterations, 1);
exec_time = mean(complete_exec_time, 1);
save('iterations_10000.txt', 'iter', '-ascii');
save('execution_time_10000.txt', 'exec_time', '-ascii');



%{
subplot(1,2,1);
hold on;
x=1:10;
plot(complete_exec_time);
title("Execution time");
subplot(1,2,2);
bar(iterations);
title("# Iterations");
%}


%profile viewer

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
