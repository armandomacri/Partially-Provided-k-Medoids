
function [membership, all_medoids, v, distances, iterations] = partially_provided_k_medoids(data, k, provided)
    [n_sample, ~] = size(data);

    if k > n_sample
        error('Error! More clusters than data points')
    end
    
    if length(provided) >= k
        error('Error! Too much medoids provided')
    end

    disp('Start K-means clustering ... ');
    
    remaning = k - length(provided);
    
    list = setdiff(1:n_sample, provided);
    permutation = list(randperm(n_sample-length(provided)));  %result
    candidate_medoids = permutation(1:remaning);
    candidate_medoids=candidate_medoids';
    
    all_medoids = cat(1,provided,candidate_medoids);
    D = pdist2(data, data, 'squaredeuclidean');
    
    poits = D(all_medoids,:);
    [distances, membership] = min(poits, [], 1);
    membership = membership';
    
    %show(data, membership, k, all_medoids, 'Cluster centres initialized!');
    
    iterations = 0;

    while true
        
        for i=length(provided)+1:k   % for aech candidate medoid
            
    %       Take distances  poits belonging cluster i
            check = (membership==i);
            keep_indexs = find(check>0);
            D_i = D(check, check);
            S = sum(D_i, 2);
    %       Select the point that minimize the sum of distances
            [~, ind] = min(S, [], 1);
            ind = keep_indexs(ind);
    %       Update medoid i
            all_medoids(i) = ind;
    
        end

        poits = D(all_medoids,:);
        [distances, new_membership] = min(poits, [], 1);
        new_membership = new_membership';
        
        iterations = iterations+1;

        %show(data, new_membership, k, all_medoids, 'Cluster centres initialized!');
        
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