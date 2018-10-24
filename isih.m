function isih(I, nbins, sf, filename)

figure;
[ISIH, t] = hist(I, nbins);
if(length(t)>1)
    stepsize = t(2)-t(1);
    bar(1000*(t-stepsize/2)/sf, ISIH);
    xlabel('ms');
    ylabel('cts/bin');
    title([filename, ' ISIH']);
else
    disp('ISIH: nbin too small.')
end