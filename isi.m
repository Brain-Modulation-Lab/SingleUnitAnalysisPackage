%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ISI() function
%
%   Construct a vector of inter-spike interval (ISI) values for
%   a given threshold-discriminated vector D (see discriminate()
%   function).  Each isi value is the distance in samples
%   between consecutive non-zoro values in D.
%_______________________________________________________________
%   Arguments:
%       D = vector of threshold-discriminated spike values.
%           (see discriminate() function)
%_______________________________________________________________
%   Returns:
%       I = vector of ISI values ordered from the first to the 
%           last pair of spikes as they appear in D.
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function I = isi(D)

spike_samples = find(D~=0);
if length(spike_samples) < 2
    disp('ISI aborting: Not enough spikes in D.');
else
    I = zeros(length(spike_samples)-1,1);
    for i = 1:length(spike_samples)-1
        I(i) = spike_samples(i+1)-spike_samples(i);
    end
end