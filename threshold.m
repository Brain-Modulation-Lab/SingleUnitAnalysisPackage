function [D, i, threshold] = threshold(F, H, sf, threshold, polarity, filename)

D = discriminate(H, threshold, polarity);
i = find(D~=0);
D(i) = threshold;

% figure;
% plot((1:length(F))/sf, F)
% title([filename, ' threshold = ', num2str(threshold), ' uV']);
% xlabel('seconds');
% ylabel('uV');
% hold on;
% plot(find(D~=0)/sf, nonzeros(D), '+', 'color', 'red');