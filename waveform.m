%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   WAVEFORM() function
%
%   Given a signal trace F and vector of indices i that indicate 
%   spike locations in F, construct a 2-D array where each row
%   contains a window around each spike in F.  The window is 
%   defined using the prespike and postspike arguments.
%_______________________________________________________________
%   Arguments:
%       F = vector of voltages in the signal.
%       i = vector of spike locations in F; can be obtained
%           using i = find(D~=0) at command line.
%       prespike = time interval in milliseconds between the 
%                   start of waveform window and the spike peak.
%       postspike = time interval in milliseconds between the  
%                   spike peak and the end of waveform window.
%_______________________________________________________________
%   Returns:
%       W = 2-D array where each row contains a window around 
%           each spike in F.
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [W, Wm, Ws] = waveform(F, i, sf, prespike, postspike, filename)

unit = 1000; %display millisecs

prespike = round(prespike*sf/unit); %convert to samples
postspike = round(postspike*sf/unit); %convert to samples

timescale = unit*((1:(prespike+postspike+1))-prespike-1)/sf;

W = zeros((prespike+postspike)+1, length(i));

discard = []; k=0;
for(j = 1:length(i)) 
    if((i(j)-prespike)>0 & (i(j)+postspike)<=length(F))
        W(:,j)=F(i(j)-prespike:i(j)+postspike); 
    else
        k=k+1;
        discard(k) = j;
    end
end

W(:,discard) = [];

    Wm = mean(W, 2);
    Ws = std(W, 0, 2);
    
%      figure;
% %     %plot(timescale, Wm, 'LineWidth', 2);
%      hold on
% %     %plot(timescale, Wm-Ws, '--')
% %     %plot(timescale, Wm+Ws, '--')
%      plot(timescale, W)
%      plot([0 0], ylim, ':', 'color', 'red')
%      xlim(unit*[-prespike postspike]/sf);
%      ylabel('mV');
%      xlabel('ms');
% %     %title([filename, ' waveform mean +/- std']);


