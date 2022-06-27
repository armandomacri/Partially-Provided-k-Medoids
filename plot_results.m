clear all; clc; close;

rng('default'); % For reproducibility
X = [randn(1000,2)*0.75+ones(1000,2);
    randn(1000,2)*0.55-ones(1000,2)];

[n,d] = size(X);

c_pred = zeros(1,n);
numGroups = length(unique(c_pred));
clr = hsv(numGroups);
hold off;
    
gscatter(X(:,1), X(:,2), c_pred, clr, '*');

pause;

k = 5;
n_fixed = 2;
permutation = randperm(n);
fixed_medoids = permutation(1:n_fixed);

[labels, medoids, v, D, iter] = partially_provided_k_medoids(X, k, fixed_medoids');

numGroups = length(unique(labels));
clr = hsv(numGroups);
gscatter(X(:,1), X(:,2), labels, clr, '*');
hold on;

plot(X(medoids(1:2), 1), X(medoids(1:2), 2), 'kd', 'DisplayName', 'Fixed Medoid');
plot(X(medoids(3:5), 1), X(medoids(3:5), 2), 'ko', 'DisplayName', 'Medoid');
pause;
