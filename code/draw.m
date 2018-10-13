function draw(data, fig, window_centre, window_width)

% DRAW Draw an image
% 
%  DRAW(D, F, M, C, W) displays D as an image with colormap M on figure F
%  with a window centeered on C, width W.
%  If F not given, 1 is assumed
%  If M is not given, viridis map is assumed.
%  If C and W not given, full range of values assumed

% ensure we have the right input parameters
narginchk(1,4);
if (nargin==1)
    figure();
else
    figure(fig)
end

map = viridis(100);

if(nargin == 4)
    % Window the data for display
    data(data < (window_centre - window_width/2)) = window_centre - window_width/2;
    data(data > (window_centre + window_width/2)) = window_centre + window_width/2;
end

% draw image in current figure
hold off;

% images are usually defined the other way up
% pcolor(flipud(data));
pcolor(data)

% change this to something else if you don't want linear interpolation
shading flat;

axis image;  % equal aspect ratio
axis off;       % no axes
set(gca,'Position',[0 0 1 1]); % fill the figure
set(gcf,'Color',[1 1 1]);        % white surround
colormap(map); 
% colorbar;
