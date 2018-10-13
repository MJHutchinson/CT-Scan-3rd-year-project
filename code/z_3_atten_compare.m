figure(12);
clf;
depths = 0.01:0.01:30;
attens = zeros(4, length(depths));

hundredkv1al = source.photons(:,1);
ideal = source.photons(:,9);

water = find(strcmp(material.name,{'Water'}));
water_coefs = material.coeffs(:, water);

titanium = find(strcmp(material.name,{'Titanium'}));
titanium_coefs = material.coeffs(:, titanium);

attens(1,:) = ct_detect(hundredkv1al, water_coefs, depths, 1);
attens(2,:) = ct_detect(ideal, water_coefs, depths, 1);
attens(3,:) = ct_detect(hundredkv1al, titanium_coefs, depths, 1);
attens(4,:) = ct_detect(ideal, titanium_coefs, depths, 1);

attens = log(attens);

hold on;
plot(depths, attens(1,:), 'b')
plot(depths, attens(2,:), 'b--')
plot(depths, attens(3,:), 'r')
plot(depths, attens(4,:), 'r--')

legend('100kVp, 1mm Al source through water', 'Ideal (0.5MeV) source through water', '100kVp, 1mm Al source through titanium', 'Ideal (0.5MeV) source through titanium', 'Location', 'East')

xlabel('Distance (cm)')
ylabel('Log Photon denity (photons per mAs/cm)')

set(gcf, 'Position', [680   558   560   320]);

hold off;