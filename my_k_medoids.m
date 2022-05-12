%This function implements K-medoids algorithm by Park & Jun 2009 to 
%partition a given dataset into k clusters. 

function [membership, medoids, distances, v, iterations] = my_k_medoids(data, k)
% Input:
%       data: the data matrix, rows are data points and columns are dimensions
%       [Each row contains one data point]
%       k: the number of desired clusters.
% Output:
%       membership: the class assignment of each data point. The output should be a
%       column vector with size(n_rows(data), 1) elements.
%
%       medoids: the location of K centroids in your result. With images,
%       each centroid corresponds to the representative color of each
%       cluster.

    %   Get the number of data points and number of features
    [n_sample, n_dim] = size(data);

    if k > n_sample
        error('Error! More clusters than data points')
    end

    disp('Start K-means clustering ... ');

    %   Step 1: (Select initial medoids)
    %   selects random matrix value to be medoid
    rng('shuffle');
    medoids = datasample(data, k);

    %   Step 2: (Assign point to clusters)
    %   In the begining, all data points are in cluster 1
    %   The "old_membership" variable is an n_sample-by-1 matrix.
    %   It saves the cluster id that each data point belongs to.
    %   Again, in the begining, all data points are in cluster 1
    old_membership = ones(n_sample, 1);
    show(data, old_membership, k, medoids, "Cluster centres initialized!");
    
    %   Calculate the distances between every data point and 
    %   every cluster centre.
    D = pdist2(data, medoids, 'squaredeuclidean');

    %   E step: Assign data points to closest clusters.
    %   Specifically, for each data point, find closest cluster centre, 
    %   and assign the data point to that cluster.

    [distances, membership] = min(D, [], 2);
    show(data, old_membership, k, medoids, 'Cluster centres initialized!');

    iterations = 0;

    while true
    %   STEP 5: Randomly select a non-medoid object i
        for i=1:k   % foe aech medoid

    %       Get poits belonging cluster i
            P_i = data(membership==i,:);
    %       Compute distance poit by point in the cluster
            D_i = pdist2(P_i, P_i, 'squaredeuclidean');
            S = sum(D_i,2);
    %       Select the point that minimize the sum of distances
            [~, ind] = min(S, [], 1);
    %       Update medoid i
            medoids(i, :) = P_i(ind, :);
        end

        D = pdist2(data, medoids, 'squaredeuclidean');
        [distances, new_membership] = min(D, [], 2);
        iterations = iterations+1;

        show(data, new_membership, k, medoids, 'Cluster centres initialized!');
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
    title(txt);
    
    for i = 1:n_cluster
        marker = mod(i,5);
        if i > 4            
            disp('Total number of clusters exceeds 4, some symbols in the plot are reused!');
        end

        plot(X(c_pred==i, 1), X(c_pred==i, 2), symbol(marker,:), 'DisplayName', strcat("Cluster", num2str(i)));
        hold on;
        plot(centres(i, 1), centres(i, 2), 'co', 'MarkerSize', 7, 'DisplayName','Medoids');
    end
    
    legend('Location','NW');
    
    %   Pause some time here.
    %   Used to show figure with enough time.
    %   You can change the pause time.
    pause(0.5);
end