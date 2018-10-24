%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FIND_MAX() function
%
%   Finds the maxima in a voltage trace V.
%_______________________________________________________________
%   Arguments:
%       V = vector of voltage values
%_______________________________________________________________
%   Returns:
%       H = vector of length(V), s.t.:
%           H(i) = V(i) if V(i) is a local maximum,
%           H(i) = 0 otherwise.
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H = find_max(V)

H = zeros(size(V));

for i = 1:length(V)-2
    if (V(i+1)>=V(i)) & (V(i+2)<V(i+1))
        H(i+1) = V(i+1);
    end
end