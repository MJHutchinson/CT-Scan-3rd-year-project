figure(14);
depths = logspace(0,0.5,5);

energies = zeros(length(source.mev), length(depths));

for m= 1:length(depths)
   energies(:,m) = source.photons(:,1);
end

energies = photons(energies, material.coeffs(:,8), depths);
plot(source.mev, energies)
xlim([0.03 0.11])
xlabel('Energy (MeV)')
ylabel('Photons per cm^2')