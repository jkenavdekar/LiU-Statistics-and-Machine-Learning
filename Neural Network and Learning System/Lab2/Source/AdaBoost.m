%% Hyper-parameters
%  You will need to change these. Start with a small number and increase
%  when your algorithm is working.

% Number of randomized Haar-features
nbrHaarFeatures = 100;
% Number of training images, will be evenly split between faces and
% non-faces. (Should be even.)
nbrTrainImages = 2000;
% Number of weak classifiers
nbrWeakClassifiers = 100;

%% Load face and non-face data and plot a few examples
%  Note that the data sets are shuffled each time you run the script.
%  This is to prevent a solution that is tailored to specific images.

load faces;
load nonfaces;
faces = double(faces(:,:,randperm(size(faces,3))));
nonfaces = double(nonfaces(:,:,randperm(size(nonfaces,3))));

figure(1);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k));
    axis image;
    axis off;
end

figure(2);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k));
    axis image;
    axis off;
end

%% Generate Haar feature masks
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3);
colormap gray;
for k = 1:25
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2]);
    axis image;
    axis off;
end

%% Create image sets (do NOT modify!)

% Create a training data set with examples from both classes.
% Non-faces = class label y=-1, faces = class label y=1
trainImages = cat(3,faces(:,:,1:nbrTrainImages/2),nonfaces(:,:,1:nbrTrainImages/2));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainImages/2), -ones(1,nbrTrainImages/2)];

% Create a test data set, using the rest of the faces and non-faces.
testImages  = cat(3,faces(:,:,(nbrTrainImages/2+1):end),...
                    nonfaces(:,:,(nbrTrainImages/2+1):end));
xTest = ExtractHaarFeatures(testImages,haarFeatureMasks);
yTest = [ones(1,size(faces,3)-nbrTrainImages/2), -ones(1,size(nonfaces,3)-nbrTrainImages/2)];

% Variable for the number of test-data.
nbrTestImages = length(yTest);

%% Implement the AdaBoost training here
%  Use your implementation of WeakClassifier and WeakClassifierError

% Set the number of classifiers we want to get
nbrClassifiers = nbrWeakClassifiers;
% Initialize the weights
W = repmat(1/nbrTrainImages, nbrTrainImages, 1);
% Store errors of the best classifiers
classifier_errors = zeros(nbrClassifiers, 1);
% Store the threshold of the best classifier
classifier_threshold = zeros(nbrClassifiers, 1);
% Store the polarity of the best classifier
classifier_p = zeros(nbrClassifiers, 1);
% Store the feature of the best classifier
classifier_feature = zeros(nbrClassifiers, 1);
% Store best predictions of the classifier
prediciton_best = zeros(nbrClassifiers, nbrTrainImages);
% Store alphas of the best classifiers
opt_alphas = zeros(nbrClassifiers, 1);


% Loop through every base classifier
for t = 1:nbrClassifiers
    
    % Store errors of the best feature
    feature_errors = zeros(nbrHaarFeatures, 1);
    % Store the threshold of the best feature
    feature_threshold = zeros(nbrHaarFeatures, 1);
    % Store the polarity of the best feature
    feature_p = zeros(nbrHaarFeatures, 1);
    
    % Loop through every feature
    for j = 1:nbrHaarFeatures

            % Pick the interesting feature
            temp_feature = xTrain(j,:);
            % Extract all possible thresholds
            thresholds = unique(temp_feature);
            thresholds(length(thresholds)+1:length(thresholds)+2) = [min(thresholds)-1, ...
                max(thresholds)+1];
            % Set the initial polarity
            p = ones(length(thresholds), 1);
            % Prepare vector for errors of each threshold
            errors_threshold = zeros(length(thresholds), 1);

            % Loop through the thresholds
            for th = 1:length(thresholds)
                predictions = WeakClassifier(thresholds(th), p(th), temp_feature);
                errors_threshold(th) = WeakClassifierError(predictions, W, yTrain);
                % Change polarity if error>0.5
                if errors_threshold(th) > 0.5
                    p(th) = -p(th);
                    predictions = WeakClassifier(thresholds(th), p(th), temp_feature);
                    errors_threshold(th) = WeakClassifierError(predictions, W, yTrain);
                end

            end

         feature_errors(j) = min(errors_threshold);
         ind = find(errors_threshold==feature_errors(j));
         feature_threshold(j) = thresholds(ind(1));
         feature_p(j)  = p(ind(1));

    end
    
    classifier_errors(t) = min(feature_errors);
    ind = find(feature_errors==classifier_errors(t));
    classifier_threshold(t) = feature_threshold(ind(1));
    classifier_p(t) = feature_p(ind(1));
    classifier_feature(t) = ind(1);
    opt_alphas(t) = 0.5 * log((1-classifier_errors(t))/classifier_errors(t));
    % Update weights
    prediciton_best(t,:) = WeakClassifier(classifier_threshold(t), classifier_p(t), xTrain(ind(1),:));
    W = W.*exp(-opt_alphas(t) * (yTrain .* prediciton_best(t,:)).');
    % Normalize weights
    W = W / sum(W, 'all');
    
end


%% Evaluate your strong classifier here
%  You can evaluate on the training data if you want, but you CANNOT use
%  this as a performance metric since it is biased. You MUST use the test
%  data to truly evaluate the strong classifier.

temp = zeros(size(classifier_feature,2),size(yTest,2));

for i = 1:size(classifier_feature,2)
    test = xTest(classifier_feature(i),:);
    temp(i,:) = WeakClassifier(classifier_threshold(i),classifier_p(i),test);
end

final_pred = sign(opt_alphas*temp);

%% Plot the error of the strong classifier as a function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.

train_error = zeros(1, nbrWeakClassifiers);
test_error = zeros(1, nbrWeakClassifiers);
% iterate all weak classifiers. in this loop when e=3, it means we will
% use first 3 weak classifiers to predict and calculate error.
for e = 1:nbrWeakClassifiers
    C = zeros(e,size(yTest,2));
    T = zeros(e,size(yTrain,2));
    for i = 1:e
        % select only optimal features (columns) in the test data
        test = xTest(classifier_feature(i),:);
        train = xTrain(classifier_feature(i),:);
        C(i,:) = WeakClassifier(classifier_threshold(i),classifier_p(i),test);
        T(i,:) = WeakClassifier(classifier_threshold(i),classifier_p(i),train);
    end
    final_pred_test = sign(opt_alphas(1:e).'*C);
    final_pred_train = sign(opt_alphas(1:e).'*T);
    test_error(e) = sum((final_pred_test ~= yTest))/size(yTest,2);
    train_error(e) = sum((final_pred_train ~= yTrain))/size(yTrain,2);
    
end
 
figure(4)
plot(1:nbrWeakClassifiers, 1-test_error)
hold on
plot(1:nbrWeakClassifiers, 1-train_error)
hold off


%% Plot some of the misclassified faces and non-faces from the test set
%  Use the subplot command to make nice figures with multiple images.

% We plot the misclassified images according to the number of weak
% classifier chosen. Studying the plot of the error we decided to pick
% exactly 60 weak classifiers to obtain the strong classifiers needed.

num_best_weak = 60;
C_best = zeros(num_best_weak,size(yTest,2));

for i = 1:num_best_weak
    % select only optimal features (columns) in the test data
    test = xTest(classifier_feature(i),:);
    C_best(i,:) = WeakClassifier(classifier_threshold(i),classifier_p(i),test);
    
end
prediciton_best = sign(opt_alphas(1:num_best_weak).'*C_best);
error_best = sum((prediciton_best ~= yTest))/size(yTest,2);

j=1;
i=1;
while j<10
    if prediciton_best(i) ~= yTest(i) 
        missclass(j) = i;
        j = j+1;
    end
    i = i+1;
end
figure(5);
colormap gray;
for k = 1:9
    subplot(3,3,k),imagesc(testImages(:,:,missclass(k)));
    axis image;
    axis off;
end

%% Plot your choosen Haar-features
%  Use the subplot command to make nice figures with multiple images.

figure(6);
colormap gray;
unique_selected_features = unique(classifier_feature);
haar_to_plot = 30
for k = 1:haar_to_plot
    subplot(6,5,k),imagesc(haarFeatureMasks(:,:,unique_selected_features(k)),[-1 2]);
    axis image;
    axis off;
end