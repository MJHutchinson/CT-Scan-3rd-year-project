function [Y] = hu(P, material, X, scale)

% HU convert CT reconstruction output to Hounsfield Units
%
%  Y = HU(P, material, X, scale) converts the output in X into Hounsfield
%  Units, using the material coefficients, photon energy P and scale given.

n = size(X,2);

% check inputs
narginchk(4,4);

% find coeffs for water
water = find(strcmp(material.name,{'Water'}));

wateruncal = ct_detect(P, material.coeffs(:,water), 2*n*scale);

% convert to HU

waterco = (ct_calibrate(P, material, wateruncal, scale))/(2*n*scale);

hound = 1000 * (X-waterco)/waterco;

Y = hound;
% limit to normal DICOM range

X(X>3072) = 3072;
X(X<-1024) = -1024;

