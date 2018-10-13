function [Y] = ct_calibrate(P, material, X, scale)

% CT_CALIBRATE convert CT detections to linearised attenuation
%
%  Y = CT_CALIBRATE(P, material, X, scale) takes the CT detection sinogram
%  in X (angles x samples) and returns a linear attenuation sinogram in Y
%  (angles x samples). P is the source energy distribution, material is the
%  material structure containing names, linear attenuation coefficients and
%  energies in mev, and scale is the size of each pixel in X, in cm.

% check inputs
narginchk(4,4);

% find coeffs corresponding to air
air = find(strcmp(material.name,{'Air'}));

% Get dimensions - air in ct_scan has depth 2*n*scale
n = size(X, 2);

% Perform calibration scan of air
I0 = ct_detect(P, material.coeffs(:,air), 2*n*scale);

% Implement equation 4
Y = -log(X/I0);

% account for beam hardening in water

water = find(strcmp(material.name,{'Water'}));

% generate seris of t to test
t = 0:1:2000;
% test attenuation on depths
depth = zeros(size(material.coeffs,2),size(t,2));
depth(water, :) = t;
depth(air,:) = 2*n-sum(depth, 1);
t = t * scale;
depth = depth * scale;

mu = ct_detect(P, material.coeffs, depth);
mu = -log(mu/I0);
mu(mu==-log(1/I0)) = [];
mu(isnan(mu)) = [];
mu(end+1) = -log(1/I0);
t(length(mu)+1:end) = [];

Y = interp1(mu, t, Y);
