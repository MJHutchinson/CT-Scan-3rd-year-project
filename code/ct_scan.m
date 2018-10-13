function [Y] = ct_scan(P, material, X, scale, angles, mas)

% CT_SCAN simulate CT scanning of an object
%
%  Y = CT_SCAN(P, material, X, scale, angles, mas) takes a phantom in X
%  which contains indices relating to the attenuation coefficients given in
%  material.coeffs, and scans it using source energy P, with given angles and
%  current-time product mas.
%
%  scale is the pixel size of the input array X, in cm per pixel.

% check inputs
narginchk(5,6);
if (nargin<6)
  mas = 10000;
end

% find the coefficients for air
air = find(strcmp(material.name,{'Air'}));

% get input image dimensions, and create a coordinate structure
n = max(size(X));
xi = ones(n,1)*[1:n]-(n/2);
yi = xi';

% scan one angle at a time
Y = zeros(angles, n);
fprintf(1, 'Scanning, angle:   0');
for a=1:angles
  fprintf(1, '\b\b\b\b%4i',a);
  
  % Get rotated coordinates for interpolation
  p = -pi/2-a*pi/angles;
  xo = xi*cos(p) - yi*sin(p) + (n/2);
  yo = xi*sin(p) + yi*cos(p) + (n/2);
  
  % For each material, add up how many pixels contain this on each ray
  depth = zeros(size(material.coeffs,2),n);
  for m=1:size(material.coeffs,2)
    if (m==air) continue; end
    depth(m,:) = sum(interp2(double(X==m), xo, yo, 'linear', 0));
  end
  
  % ensure an appropriate amount of air is included in the calculation
  % to account for the scan being circular, but the phantom being square
  % diameter of circle taken to be twice the phantom side length
  depth(air,:) = 2*n-sum(depth, 1);
  
  % scale the depth appropriately and calculate detections for this set of
  % materials
  depth = depth * scale;
  Y(a,:) = ct_detect(P, material.coeffs, depth, mas);
  
end
fprintf(1, '\n');
