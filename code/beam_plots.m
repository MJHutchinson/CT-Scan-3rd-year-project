h = xtreme_get_rsq_header('raw/raw_data_a.rsq');

width    = h.samples*h.scale;
width_2  = (h.samples-1)/2 * h.scale;
height_fan_origin   = h.fan_scans * h.scale;
height_fan_origin_2 = (h.fan_scans-1)/2 * h.scale;
heigh_layer_origin = (h.fan_scans - 2 * h.skip_scans) * h.scale;
heigh_layer_origin_2 = (h.fan_scans -2 * h.skip_scans - 1)/2 * h.scale;

[XX, YY, ZZ] = ndgrid(linspace(-width_2, width_2, h.samples), ...
                        linspace(-width_2, width_2, h.samples), ...
                        linspace(-height_fan_origin_2, height_fan_origin_2, h.fan_scans));

[xx, yy, zz] = ndgrid(linspace(-width_2, width_2, h.samples), ...
                                linspace(-width_2, width_2, h.samples), ...
                                linspace(-heigh_layer_origin_2, heigh_layer_origin_2, h.fan_scans - 2*h.skip_scans));
                            

p = 0; %pi/2+a*pi/h.recon_angles;
xx_recon = xx*cos(p) - yy*sin(p);
yy_recon = yy*cos(p) + xx * sin(p);
                            
zz_scale_factors = (xx_recon + h.radius)/h.radius;  
ZZ_scale_factor = (XX + h.radius)/h.radius;  

f = figure(1);
clf;
hold on
plot(squeeze(XX(:,1,:)), squeeze(ZZ(:,1,:).*ZZ_scale_factors(:,1,:)), 'Color', [0    0.4470    0.7410])
plot(squeeze(xx(:,1,:)), squeeze(zz(:,1,:)), 'Color', [ 0.8500    0.3250    0.0980])
f.Position = [0 0 500 400];
xlabel('Along fan centre')
ylabel('z')
print('../report final/diagrams/recon/smear_space', '-dpng', '-r0')

f = figure(2);
clf;
hold on
plot(squeeze(XX(:,1,:)), squeeze(ZZ(:,1,:)), 'Color', [0    0.4470    0.7410])
plot(squeeze(xx(:,1,:)), squeeze(zz(:,1,:)./zz_scale_factors(:,1,:)), 'Color', [ 0.8500    0.3250    0.0980])
f.Position = [0 0 500 400];
xlabel('Along fan centre')
ylabel('z')
print('../report final/diagrams/recon/smear_space_squash', '-dpng', '-r0')
