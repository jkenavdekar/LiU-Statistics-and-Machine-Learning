function C = WeakClassifier(T, P, X)
% WEAKCLASSIFIER Classify images using a decision stump.
% Takes a vector X of scalars obtained by applying one Haar-feature to all
% training images. Classifies the examples using a decision stump with
% cut-off T and parity P. Returns a vector C of classifications for all
% examples in X.

C = (X > T)*P + (~(X > T))*(-P);

end

