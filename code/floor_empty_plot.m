[slice, slice_min, slice_max] = xtreme_get_rsq_slice(hc, 320);
f = figure(1);
plot(slice_min)
xlabel('Detector')
ylabel('Beam intensity')
f.Position = [0 0 300 250];
% print('../report final/diagrams/recon/floor', '-depsc', '-r0')

f = figure(2);
plot(slice_max)
xlabel('Detector')
ylabel('Beam intensity')
f.Position = [300 0 300 250];
% print('../report final/diagrams/recon/empty', '-depsc', '-r0')

