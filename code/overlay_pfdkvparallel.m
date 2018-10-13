f = figure(5);
clf;
hold on;

rotate = -2.7;
translate = [-0.007;0.002];

slice1 = flip(recon_block_a(:,:,545));
slice2 = flip(xtreme_rotate_translate(recon_block_a(:,:,635), rotate, [0.5;0.5], translate), 1);

m = mean(mean(slice1));

slice1 = double(slice1>m);
slice2 = -double(slice2>m);
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
print('../report final/diagrams/recon/overly_good', '-dpng', '-r0')
