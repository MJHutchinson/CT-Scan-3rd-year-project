figure(11);
plot(source.mev, source.photons);
l = legend(source.name);
xlabel('Energy (MeV)');
xlim([0 0.12]);
ylabel('Photon denity (photons per mAs/cm)');
%get(gcf, 'Position')
set(gcf, 'Position', [680   558   560   320])