[xx, yy] = ndgrid(1:507);

xx = xx-1;
yy = yy-1;

xx = reshape(xx, 1, []);
yy = reshape(yy, 1, []);
coords = [xx;yy];

R = [cos(deg2rad(5)) -sin(deg2rad(5)) ; sin(deg2rad(5)) cos(deg2rad(5))];

centre = [506;506];

coords_r = R*(coords - centre) + centre;

xx = reshape(xx, 507, 507);
yy = reshape(yy, 507, 507);

xxr = coords_r(1,:);
yyr = coords_r(2,:);

xxr = reshape(xxr, 507, 507);
yyr = reshape(yyr, 507, 507);
