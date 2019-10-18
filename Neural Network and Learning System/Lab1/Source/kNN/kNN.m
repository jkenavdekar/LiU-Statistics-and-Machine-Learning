function [ labelsOut ] = kNN(X, k, Xt, Lt)
%KNN Your implementation of the kNN algorithm
%   Inputs:
%               X  - Features to be classified
%               k  - Number of neighbors
%               Xt - Training features
%               LT - Correct labels of each feature vector [1 2 ...]'
%
%   Output:
%               LabelsOut = Vector with the classified labels

% Initialize variables
labelsOut  = zeros(size(X,2),1);    % Our predictions
classes = unique(Lt);   % Possible classes
numClasses = length(classes);   % Number of classes
n_train = size(Xt, 2);  % Observations in train
n_test = size(X, 2);    % Observations in test

% Distance matrix between train(rows) and test(columns)
distances = pdist2(transpose(Xt), transpose(X));
distances(:,n_test+1) = Lt;   % Add column with real classes of train

for i = 1:n_test
    sorted_dist = sortrows(distances, i);  % Sort matrix by column i
    temp_class = sorted_dist(1:k,n_test+1);  % Classes of k nearest training points
    table = tabulate(temp_class);   % Count number of each class for neighbour
    temp_max = max(table(:,2));  % Highest frequency in table
    ind_max = find(table(:,2)==temp_max);   % Which is/are the top classes?
    top_classes = table(ind_max,1);  % Select top classes
    
    if length(ind_max) > 1    % Do we have a clear majority?
        best_class = randsample(top_classes, 1);    % Pick one of them at random
        
    else
        % We have a clear majority, we pick just the class with the highest frequency
        best_class = top_classes;  
    
    end

labelsOut(i) = best_class;  % Save our prediciton for the column i

end