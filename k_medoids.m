clear all; clc; close;

data = [randn(100,2)*0.75+ones(100,2);
    randn(100,2)*0.55-ones(100,2)];

tollerance = 1e-5;
k=2;

[n_sample, n_dim] = size(data);

rng('shuffle');
medoids = datasample(data, k);


disp('Start K-means clustering ... ');

old_membership = ones(n_sample, 1);

D = pdist2(data, medoids, 'squaredeuclidean');
[distances, membership] = min(D, [], 2);

% STEP 4: Compute the total cost 
% it is the total sum of all the non-medoid objects distance from its 
% cluster medoid.
v_old = sum(distances);

iterations=0;
while true

%   STEP 5: Randomly select a non-medoid object i
    for i=1:k   % foe aech medoid
        
%      Get poits belonging cluster i
       P_i = data(membership==i,:);
%      Compute distance poit by point in the cluster
       D_i = pdist2(P_i, P_i, 'squaredeuclidean');
       S = sum(D_i);
%      Select the point that minimize the sum of distances
       [~, ind] = min(S, [], 2);
%      Update medoid i
       medoids(i, :) = P_i(ind, :);
    end
    
    D = pdist2(data, medoids, 'squaredeuclidean');
    [distances, new_membership] = min(D, [], 2);
    
    v = sum(distances);
    
    iterations = iterations+1;
    
    % Stop if no more updates.
    if sum(membership ~= new_membership)==0
        
        break;
    end
    
    %{
    if v_old - v < tollerance
        disp('End ');
        break;
    end
    %}
    
    v_old = v;
end