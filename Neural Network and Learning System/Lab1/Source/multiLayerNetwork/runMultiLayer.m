function [ Y, L ] = runMultiLayer( X, W, V )
%RUNMULTILAYER Calculates output and labels of the net
%   Inputs:
%               X  - Features to be classified (matrix)
%               W  - Weights of the hidden neurons (matrix)
%               V  - Weights of the output neurons (matrix)
%
%   Output:
%               Y = Output for each feature, (matrix)
%               L = The resulting label of each feature, (vector) 

S = transpose(W)*X; %Calculate the sumation of the weights and the input signals (hidden neuron)
U1 = tanh(S); %Calculate the activation function as a hyperbolic tangent
U = ones(1, size(U1, 2));
U(2:size(U1, 1)+1,:) = U1;
Y = transpose(V)*U; %Calculate the sumation of the output neuron
   

% Calculate classified labels
[~, L] = max(Y,[],1);
L = L(:);

end

