figure(12);
depths = [0.01:0.01:30];
attens = zeros(length(material.name), length(depths));



for m=1:length(material.name)
  attens(m,:) = ct_detect(source.photons(:,9), material.coeffs(:,m), depths, 1);
end


attens = log(attens);
plot(depths, attens);

l = legend(material.name);
l.Location = 'bestoutside';

xlabel('Distance (cm)')
ylabel('Log Photon denity (photons per mAs/cm)')

set(gcf, 'Position', [680   558   560   320]);