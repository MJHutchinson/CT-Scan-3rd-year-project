figure(10);
clf;
loglog(material.mev, material.coeffs);
xlim([0 0.2]);
l = legend(material.name);
l.Location = 'bestoutside';
xlabel('Energy (MeV)');
ylabel('Attenuation coefficient/cm')
%pos = get(gcf, 'Position');
set(gcf, 'Position', [680   558   560   320])