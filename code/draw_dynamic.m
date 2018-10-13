function draw_dynamic(data, fig, map, window_centre, window_width);
% DRAW_DYNAMIC Draw an image with sliders to allow for dynamic windowing of
% the image
% 
%  DRAW_DYNAMIC(D, F, M, C, W) displays D as an image with colormap M on figure F
%  with a window centeered on C, width W.
%  If F not given, 1 is assumed
%  If M is not given, viridis map is assumed.
%  If C and W not given, full range of values assumed
% ensure we have the right input parameters
narginchk(1,5);
if (nargin==1)
    map = viridis(100);
    fig = 1;
    window_width = max(max(data)) - min(min(data));
    window_centre = (window_width)/2 + min(min(data));
end
    
if (nargin==2)
  map = viridis(100);
  window_width = max(max(data)) - min(min(data));
  window_centre = (window_width)/2 + min(min(data));
end

if (nargin==3)
  window_width = max(max(data)) - min(min(data));
  window_centre = (window_width)/2 + min(min(data));
end

data_orig = data; % store original data

figure(fig)

% set up sliders for window positions
window_position=uicontrol('style','slider','position',[10 0 200 20],...
    'min',min(min(data_orig)),'max', max(max(data_orig)),'callback',@window_pos, 'value', window_centre);

window_w=uicontrol('style','slider','position',[10 20 200 20],...
    'min',0,'max', max(max(data_orig))-min(min(data_orig)),'callback',@window_wid, 'value', window_width);

% draw initial window
p();


    % callbacks for change in slider positions
    function window_pos(source, eventdata)
        window_centre = get(window_position, 'value');
        p();
    end

    function window_wid(source, eventdata)
        window_width = get(window_w, 'value');
        p();
    end

    function p()
        % Window th data for display
        data = data_orig;
        data(data < (window_centre - window_width/2)) = window_centre - window_width/2;
        data(data > (window_centre + window_width/2)) = window_centre + window_width/2;
        
        % images are usually defined the other way up
        pcolor(flipud(data));

        % change this to something else if you don't want linear interpolation
        shading interp;

        axis image;  % equal aspect ratio
        axis off;       % no axes
        % set(gca,'Position',[0 0 1 1]); % fill the figure
        set(gcf,'Color',[1 1 1]);        % white surround
        colormap(map);
        colorbar;
        
        window_centre
        window_width
    end

end