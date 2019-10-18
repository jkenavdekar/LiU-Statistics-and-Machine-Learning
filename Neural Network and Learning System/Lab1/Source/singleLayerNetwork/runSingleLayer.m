function [ Y, L ] = runSingleLayer(X, W)
%EVALUATESINGLELAYER Summary of this function goes here
%   Inputs:
%               X  - Features to be classified (matrix)
%               W  - Weights of the neurons (matrix) 
%                    Dimensions: (#input_nodes x #output_nodes)
%
%   Output:
%               Y = Output for each feature, (matrix)
%               L = The resulting label of each feature, (vector) 

% BIAS ADDED IN THE FILE "evaluate_SingleLayer.m"
Y = transpose(W)*X;

% Calculate classified labels
[~, L] = max(Y,[],1);
L = L(:);
end

