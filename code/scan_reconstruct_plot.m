function [reconstruction, sinogram, filtered_sinogram, poor_reconstruction] = scan_reconstruct_plot(P, material, X, scale, angles, mas, alpha)
% SCAN_RECONSTRUCT_PLOT Simulation of the CT scanning process and then plot
% relevant figures
%
%  Y = SCAN_RECONSTRUCT_PLOT(P, material, X, scale, angles, mas, alpha)
%  takes the phantom data in X (samples x samples), scans it using the
%  source P and material information given, as well as the scale (in cm),
%  number of angles, time-current product in mas, and raised-cosine power
%  alpha for filtering. The output Y is the same size as X. Also outputs a
%  number of other relevant plots
narginchk(5,7);
if (nargin<7)
  alpha = 0.001;
end
if (nargin<6)
  mas = 100;
end

% Prform th can nd reconstruction
[reconstruction, sinogram, filtered_sinogram, poor_reconstruction] = scan_and_reconstruct(P, material, X, scale, angles, mas, alpha);
% Plot the rlevant images
multi_draw(X, sinogram, filtered_sinogram, reconstruction);

end

