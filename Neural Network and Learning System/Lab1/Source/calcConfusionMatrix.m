function [ cM ] = calcConfusionMatrix( Lclass, Ltrue )
classes = unique(Ltrue);
numClasses = length(classes);
cM = zeros(numClasses);
n = length(Lclass);

for i=1:n
    cM(Lclass(i),Ltrue(i)) = cM(Lclass(i),Ltrue(i))+1;
end

end

