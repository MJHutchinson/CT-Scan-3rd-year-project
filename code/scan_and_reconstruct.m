function [Y, sinogram, filtered_sinogram, unfiltereed_backproject] = scan_and_reconstruct(P, material, X, scale, angles, mas, alpha)

% SCAN_AND_RECONSTRUCT Simulation of the CT scanning process
%
%  Y = SCAN_AND_RECONSTRUCT(P, material, X, scale, angles, mas, alpha)
%  takes the phantom data in X (samples x samples), scans it using the
%  source P and material information given, as well as the scale (in cm),
%  number of angles, time-current product in mas, and raised-cosine power
%  alpha for filtering. The output Y is the same size as X. Also outputs a
%  number of other relevant plots

% check inputs
narginchk(5,7);
if (nargin<7)
  alpha = 0.001;
end
if (nargin<6) 
  mas = 100;
end

% create sinogram from phantom data, with received detector values
sinogram = ct_scan(P, material, X, scale, angles, mas);

% convert detector values into attenuation values
sinogram = ct_calibrate(P, material, sinogram, scale);

% Filter
filtered_sinogram = ramp_filter(sinogram, scale, alpha);

% Back-projection of unflitered sinogram for comparison
unfiltereed_backproject = back_project(sinogram);

% Backprojection of filtered sinogram for actual 
Y = back_project(filtered_sinogram);


