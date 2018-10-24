%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   HIGHPASS() function
%
%   Eliminate low-frequency component in signal
%   This filter was designed using the MATLAB filter design tool
%   which can be accessed by typing fdatool at command line.
%_______________________________________________________________
%   Arguments:
%       V = vector to be filtered
%_______________________________________________________________
%   Returns:
%       F = filtered vector
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F = highpass(V)

%Define filter coefficients
%IIR Elliptic filter: fs=2000Hz, fstop=1Hz, fpass=15Hz, Astop=45dB, Apass=1dB
%Filter created using MATLAB filter design tool
Num = [0.8705, -1.7410, 0.8705];
Den = [1.0000, -1.9525, 0.9544];

%filter data
F = filter(Num, Den, V);