function Fm = meanfreq(I, sampling_frequency)

if(mean(I ~= 0))
    Fm = sampling_frequency/mean(I);
end