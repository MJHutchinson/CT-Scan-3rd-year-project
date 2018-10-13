function [] = multi_draw(varargin)
% MULTI_DRAW Draw each given image on a grid, as square as possible
% 
%  MULTI_DRAW(varargin) for each input, draw the image

cols = ceil(sqrt(nargin)); % compute rows and columns needed
rows = ceil(nargin/cols);

% use th subtightplot unction to reduce gaps between plots in th grid. Uses
% the subtightplot.m function from the mathworks file echange, by  Felipe G. Nievinski
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
if ~make_it_tight,  clear subplot;  end

% use the viridis colour map by Nathaniel Smith and Stéfan van der Walt
map = viridis(100);

figure

for i = 1:nargin
    
    % selct the relvant subplot
    subplot(rows, cols, i);
     
    % images are usually defined the other way up
    pcolor(flipud(varargin{i}));
    % change this to something else if you don't want linear interpolation
    shading interp;

    axis image;  % equal aspect ratio
    axis off;       % no axes
    %set(gca,'Position',[0 0 1 1]); % fill the figure
    set(gcf,'Color',[1 1 1]);        % white surround
    colormap(viridis);
    %caxis([0, 10]);
    colorbar; 
    
end
