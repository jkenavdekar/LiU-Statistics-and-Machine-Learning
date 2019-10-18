%% This script will help you test out your kNN code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 4; % Change this to load new data 

[X, D, L] = loadDataSet( dataSetNr );

% You can plot and study dataset 1 to 3 by running:
% plotCase(X,D)

%% Select a subset of the training features

numBins = 2; % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = 100; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true; % true = select features at random, false = select the first features
rng(1530);

[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

% Note: Xt, Dt, Lt will be cell arrays, to extract a bin from them use i.e.
% XBin1 = Xt{1};

%% Use kNN to classify data
% Note: you have to modify the kNN() function yourselfs.

% Set the number of neighbors
K = 40;
folds = 4;  % Set number of folds
errors = zeros(folds, K);   % Matrix where to store the errors of each fold
n = size(Xt{1},2);
index_shuffling = randperm(n);  % Indexes to shuffle data
shuffled_train = Xt{1}(:,index_shuffling);
shuffled_y = Lt{1}(index_shuffling);

for k = 1:K
    for fold = 1:folds
        indexes_test = fold:folds:n;    % 1st fold: 1 5 9  ... n-3
                                        % 2nd fold: 2 6 10 ... n-2
                                        % 3rd fold: 3 7 11 ... n-1
                                        % 4th fold: 4 8 12 ... n
        indexes_train = setdiff(1:n,indexes_test);  % What is not test
        X_test = shuffled_train(:,indexes_test);
        X_train = shuffled_train(:,indexes_train);
        Y_test = shuffled_y(indexes_test);
        Y_train = shuffled_y(indexes_train);
        % Predict new data for the present fold and k:
        temp_Knn = kNN(X_test, k, X_train, Y_train);    
        
        % The confusionMatrix
        temp_cM = calcConfusionMatrix(temp_Knn, Y_test);

        % The accuracy (stored in the errors matrix)
        errors(fold, k) = calcAccuracy(temp_cM);
        
    end
    
end

% Not exactly the MSE, we take the average accuracy per fold (row of matrix)
MSE = mean(errors);
best_MSE = max(MSE);    % Select the best one
best_k = find(MSE==best_MSE);   % Find the K that gives the best accuracy
% N.B. It may be a vector: we will take the smallest as the actual best

LkNN = kNN(Xt{2}, best_k(1), Xt{1}, Lt{1});

%% Calculate The Confusion Matrix and the Accuracy
% Note: you have to modify the calcConfusionMatrix() function yourselfs.

% The confucionMatrix
cM = calcConfusionMatrix( LkNN, Lt{2})

% The accuracy
acc = calcAccuracy(cM)

best_k(1)

%% Plot classifications
% Note: You do not need to change this code.
if dataSetNr < 4
    plotkNNResultDots(Xt{2},LkNN,best_k(1),Lt{2},Xt{1},Lt{1});
else
    plotResultsOCR( Xt{2}, Lt{2}, LkNN )
end
