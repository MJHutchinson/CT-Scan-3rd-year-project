function [Y] = xtreme_fan_to_parallel( h, X )

% XTREME_FAN_TO_PARALLEL  convert raw Xtreme sinogram to parallel
%
%  Y = XTREME_FAN_TO_PARALLEL(h, X) takes the raw sinogram in X (h.angles x
%  h.samples) and uses the information in the structure h to convert this 
%  to an equivalent parallel-beam sinogram in Y (h.recon_angles x
%  h.samples).

% check inputs
narginchk(2,2);

% calculate some required parameters
angles = h.recon_angles;
samples = h.samples;
atheta = h.fan_theta/6; % 1/6 of the fan angle
c = h.samples/2 - 0.5; % the centre sample

% input coordinates for the data in X
xi = ones(h.angles,1)*[1:h.samples];
yi = [1:h.angles]'*ones(1, h.samples);

% initialise output coordinates and data
Y = zeros(angles, samples);
xo = zeros(angles, samples);
yo = zeros(angles, samples);

% form output coordinates - y0 is zero-based at this point
xo1 = ones(angles,1)*[1:samples];
yo1 = [1:angles]'*ones(1, samples);
yo = asin((xo1-(samples/2))/h.radius);

% n1, n2 and n3 signify samples on one of three separate detector arrays,
% each occupying one-third of the fan angle
n1 = (yo>atheta);
n2 = (yo<-atheta);
n3 = ~n1 & ~n2;

% this gives the correct conversion for each one of the detector arrays
xo(n1) = (xo1(n1)-(5*samples/6))./cos(yo(n1)-2*atheta) + c + samples/3;
xo(n2) = (xo1(n2)-(samples/6))./cos(yo(n2)+2*atheta) + c - samples/3;
xo(n3) = (xo1(n3)-(samples/2))./cos(yo(n3)) + c;

% adjust angle so it is not zero-based
yo = yo/h.dtheta + yo1 + h.skip_angles/2 + h.fan_angles/2 - 0.5;

% actually perform the interpolation
Y = interp2(xi, yi, X, xo, yo, '*linear', 0);

