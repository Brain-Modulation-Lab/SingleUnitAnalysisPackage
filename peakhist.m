function peakhist(H, filename)

[S, vo] = spikehist(H);

figure;
plot(vo, S, 'Marker', '.', 'MarkerSize', 5);
xlabel('mV');
ylabel('cts/bin');
title([filename, ' Peak histogram']);