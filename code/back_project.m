function [Y] = back_project(X)

% BACK_PROJECT back-projection to reconstruct CT data
%
% Y = BACK_PROJECT(X) back-projects the filtered sinogram in X
% (angles x samples) to create the reconstruted data in Y (samples x
% samples).

% check inputs
narginchk(1,1);

% get input dimensions
n = size(X,2);
angles = size(X,1);

% zero output and form input coordinates
% these have centre in the middle of the image
Y = zeros(n, n);
xi = ones(n,1)*[1:n] - (n/2);
yi = xi';

% back project over each angle in turn
%fprintf(1, 'Back-projecting, angle:   0');
for a=1:angles
  %fprintf(1, '\b\b\b\b%4i',a);
  
  % Form rotated coordinates for output interpolation
  % the rotation is about the middle of the image,
  % but the output coordinates need to be relative to the top left
  p = pi/2+a*pi/angles;
  xo = xi*cos(p) - yi*sin(p) + (n/2);
  
  % interpolate and add this data to output
  % remembering to multiply by dtheta as well as sum
  x2 = interp1(X(a,:), xo, 'linear', 0);
  Y = Y+x2*(pi/angles);
  
end

% ensure any data outside the reconstructed circle is set to invalid
Y((xi.^2+yi.^2) > (n/2)^2) = 0;
%fprintf(1, '\n');