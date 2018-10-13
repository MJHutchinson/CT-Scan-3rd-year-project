function [slice] = xtreme_rotate_translate(slice, angle, centre, shift)
    [xx, yy] = ndgrid(1:length(slice));

    xx = xx-1;
    yy = yy-1;

    xx = reshape(xx, 1, []);
    yy = reshape(yy, 1, []);
    coords = [xx;yy];

    R = [cos(deg2rad(angle)) -sin(deg2rad(angle)) ; sin(deg2rad(angle)) cos(deg2rad(angle))];

    centre = centre * length(slice);

    coords_r = R*(coords - centre) + centre - (shift * length(slice));

    xx = reshape(xx, length(slice), length(slice));
    yy = reshape(yy, length(slice), length(slice));

    xxr = coords_r(1,:);
    yyr = coords_r(2,:);

    xxr = reshape(xxr, length(slice), length(slice));
    yyr = reshape(yyr, length(slice), length(slice));
    
    f = griddedInterpolant(xx, yy, slice, 'linear', 'nearest');
    
    slice = f(xxr, yyr);
end

