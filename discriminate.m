%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   DISCRIMINATE() function
%
%   Selects the peaks that satisfy a threshold criterion.
%_______________________________________________________________
%   Arguments:
%       H = vector of minimum of maximum voltage values
%           (see find_min and find_max functions)
%       threshold = threshold voltage value
%       polarity = +1 if H contains maxima
%                  -1 if H contains minima
%_______________________________________________________________
%   Returns:
%       D = vector of length(V), s.t.:
%           D(i) = V(i) if V(i) is a peak that meets threshold,
%           D(i) = 0 otherwise.
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D = discriminate(H, threshold, polarity)

D = zeros(size(H));

if polarity < 0
    spikes = find(H < threshold);
else
    spikes = find(H > threshold);
end

D(spikes) = H(spikes);