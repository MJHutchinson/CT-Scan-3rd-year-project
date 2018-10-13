f = figure(5);
clf;
hold on;

rotate = -2.7;
translate = [-0.007;0.002];

slice1 = recon_block_a(:,:,525)';
slice2 = xtreme_reconstruct_slice(ha, 615, 0.001);

slice1 = (slice1 - min(min(slice1)))./(max(max(slice1)) - min(min(slice1)));
slice2 = (slice2 - min(min(slice2)))./(max(max(slice2)) - min(min(slice2)));


m1 = mean(mean(slice1));
m2 = mean(mean(slice2));

slice1 = double(slice1>m1);
slice2 = -double(slice2>m2);
slice1(slice1==0) = NaN;
slice2(slice2==0) = NaN;

p1 = pcolor(slice1);

shading flat;
axis image;  % equal aspect ratio
axis off;       % no axes

p2 = pcolor(slice2);

shading flat;
axis image;  % equal aspect ratio
axis off;       % no axes
colormap('winter');

set(p2, 'facealpha', 0.4);
f.Position = [0 0 500 500];
print('../report final/diagrams/recon/parallel_v_PFDK_edge_fan', '-dpng', '-r0')
