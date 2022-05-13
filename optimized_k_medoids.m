function [membership, medoids, v, distances, iterations] = optimized_k_medoids(data, k)
% Input:
%       data: the data matrix, rows are data points and columns are dimensions
%       [Each row contains one data point]
%       k: the number of desired clusters.
% Output:
%       membership: the class assignment of each data point. The output should be a
%       column vector with size(n_rows(data), 1) elements.
%
%       medoids: the indexes of the k medoids
%
%       v: total cost function
%
%       distances: matrix of distances point to medoid M(data(0), k)
%
%       iterations: # of iteration involved in the algorithm

    %   Get the number of data points and number of features
    [n_sample, ~] = size(data);

    if k > n_sample
        error('Error! More clusters than data points')
    end

    disp('Start K-means clustering ... ');

    %   STEP 1: (Select initial medoids)
    %   selects random matrix value to be medoid
    permutation = randperm(n_sample);
    medoids = permutation(1:k);
    
    %   Compute the distance between all the points
    D = pdist2(data, data, 'squaredeuclidean');
    
    %   Step 2: (Assign point to clusters)
    %   In the begining, all data points are in cluster 1
    %   The "old_membership" variable is an n_sample-by-1 matrix.
    %   It saves the cluster id that each data point belongs to.
    %   Again, in the begining, all data points are in cluster 1
    poits = D(medoids,:);
    [distances, membership] = min(poits, [], 1);
    membership = membership';

    %show(data, membership, k, medoids, 'Cluster centres initialized!');

    iterations = 0;

    while true
        
        for i=1:k   % for aech candidate medoid
            
    %       Take distances  poits belonging cluster i
            check = (membership==i);
            keep_indexs = find(check>0);
            D_i = D(check, check);
            S = sum(D_i, 2);
    %       Select the point that minimize the sum of distances
            [~, ind] = min(S, [], 1);
            ind = keep_indexs(ind);
    %       Update medoid i
            medoids(i) = ind;
    
        end

        poits = D(medoids,:);
        [distances, new_membership] = min(poits, [], 1);
        new_membership = new_membership';
        
        iterations = iterations+1;

        %show(data, new_membership, k, medoids, 'Cluster centres initialized!');
        
    %   Stop if no more updates.
        if sum(membership ~= new_membership)==0
            disp('End ');
            v = sum(distances);
            break;
        end
        membership = new_membership;

    end
    
end

function show(X, c_pred, n_cluster, centres, txt)
    symbol = ['b.'; 'r.'; 'g.'; 'k.'; 'r.'];
    hold off;

    
    for i = 1:n_cluster
        marker = mod(i,5);
        if i > 4            
            disp('Total number of clusters exceeds 4, some symbols in the plot are reused!');
        end

        plot(X(c_pred==i, 1), X(c_pred==i, 2), symbol(marker,:), 'DisplayName', strcat("Cluster", num2str(i)));
        hold on;
        
    end
    plot(X(centres, 1), X(centres, 2), 'co', 'MarkerSize', 7);
    %legend('Location','NW');
    
    %   Pause some time here.
    %   Used to show figure with enough time.
    %   You can change the pause time.
    pause(0.5);
end