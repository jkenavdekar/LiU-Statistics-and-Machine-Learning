function out = sample(values,probs)
% SAMPLE randomly selects one of the given values with the given probabilies.
%
% Example:
% out = SAMPLE([1 2 3 4], [0.2 0.1 0.1 0.6]);
% will give out=1 with probability 0.2, out=2 with prob. 0.1 etc... 
  
p = cumsum(probs(:));
p = p / p(end);
out = find(p > rand);
out = values(out(1));

end