function [Y] = ramp_filter(X, scale, alpha, d)

% RAMP_FILTER Ram-Lak filter with raised-cosine for CT reconstruction
%
%  Y = RAMP_FILTER(X) filters the input in X (angles x samples)
%  using a Ram-Lak filter.
%
%  Y = RAMP_FILTER(X, alpha) can be used to modify the Ram-Lak filter by a
%  cosine raised to the power given by alpha.

% check inputs
narginchk(2,4);
if(nargin<4)
  d = 1;
end
if (nargin<3)
  alpha = 0.001;
end


% get input dimensions
n = size(X,2);
angles = size(X,1);

% Set up filter length m to be a power of 2, and at least twice as long as input
% to prevent spatial domain aliasing and to speed up the FFT
m = floor(log(n)/log(2)+2);
m = 2^m;

% pad with extra zeros
X(1, m) = 0;

% take FFT of sinogram
X = fft(X, m, 2);

% make ram-lak filter
H = (0:(m/2))./m; % ramp up to halfway - filter symetric

% compute w
w = 2*pi*(0:m/2)/m;

% compute the ram-lak * cosine filter
H = H .* (cos(w/2*d)).^alpha;

% adjust the first value to be the correct avarage of the region it covers
H(1) = 1/(4*m);

% adjust requencies for sample frequency
H = H/scale;

% limit to w_max
H(w>pi*d) = 0;

% Symetric filter
H = [H' ; H(end-1:-1:2)']';

% extend filter to all rows to avoid looping
H = ones(angles, 1) * H;

% apply filter to all angles
X = X .* H;

% Ifft X
X = ifft(X, m, 2);

% truncate X back to initial length
X(:, n+1:end) = [];

Y = X;



