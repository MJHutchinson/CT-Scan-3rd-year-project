function [X] = ct_phantom(names, n, type, metal)

% CT_PHANTOM create phantom for CT scanning
%
%  X = CT_PHANTOM(names, n, type, metal) creates a CT phantom in X of
%  size (n X n), and type given by type:
%
%    1 - simple circle for looking at calibration issues
%    2 - point attenuator for looking at resolution
%    3 - single large hip replacement
%    4 - bilateral hip replacement
%    5 - sphere with three satellites
%    6 - disc and other sphere
%    7 - pelvic fixation pins
%
%  For types 3-7, the metal implants are of type given by 'metal', which
%  must match one of the material names given in 'names'. Set this to
%  'Soft Tissue' if you do not want the implant.
%
%  The output X has data values which correspond to indices in the names
%  array, which must also contain 'Air', 'Adipose', 'Soft Tissue' and
%  'Bone'.

% check inputs
narginchk(3,4);
if (nargin<4) 
  metal = 'Titanium';
end

% Get material locations
air = find(strcmp(names,{'Air'}));
adipose = find(strcmp(names,{'Adipose'}));
tissue = find(strcmp(names,{'Soft Tissue'}));
bone = find(strcmp(names,{'Bone'}));
nmetal = find(strcmp(names, metal));

if (type==1)
  
  % simple circle for looking at calibration
  t = [1 0.75 0.75 0.0 0.0 0];
  X = phantom(t,n);
  X(X>=1) = tissue;
  
elseif (type==2)
  
  % impulse for looking at resolution
  X = zeros(n,n);
  X(n/2,n/2) = tissue;
  
else
  
  % This creates a generic human hip cross-section
  t =  [1 0.57 0.52 -0.35 0.1 0;
    1 0.57 0.52 0.35 0.1 0;
    1 0.52 0.45 0 -0.08 0];
  X = phantom(t,n);
  X(X>=1) = tissue;
  a = [1 0.55 0.5 -0.35 0.1 0;
    1 0.55 0.5 0.35 0.1 0;
    1 0.5 0.43 0 -0.08 0];
  X = X + phantom(a,n);
  X(X>tissue) = adipose;
  t =  [1 0.37 0.35 -0.42 0.03 0;
    1 0.37 0.35 0.42 0.03 0
    1 0.24 0.16 -0.3 0.28 20;
    1 0.24 0.16 0.3 0.28 -20;
    1 0.4 0.2 0 -0.15 0];
  X = X + phantom(t,n);
  X(X>adipose) = tissue;
  b = [1 0.16 0.12 -0.54 -0.01 0;
    -1 0.11 0.10 -0.53 -0.01 0;
    1 0.16 0.12 0.54 -0.01 0;
    -1 0.11 0.10 0.53 -0.01 0;
    1 0.1 0.09 -0.25 0.25 140;
    -1 0.07 0.06 -0.25 0.25 140;
    1 0.18 0.05 -0.05 -0.15 100;
    -1 0.14 0.03 -0.05 -0.15 100;
    1 0.1 0.09 0.25 0.25 -140;
    -1 0.07 0.06 0.25 0.25 -140;
    1 0.18 0.05 0.05 -0.15 -100;
    -1 0.14 0.03 0.05 -0.15 -100];
  X = X + phantom(b,n);
  X(X>tissue) = bone;
  
  % this adds a metal implant
  if (nmetal>tissue)
    if (type==3)
      % single large hip replacement
      m = [100 0.1 0.1 -0.48 -0.01 0];
    elseif (type==4)
      % bilateral hip replacement
      m = [100 0.1 0.1 -0.48 -0.01 0;
        100 0.08 0.06 0.48 0 0];
    elseif (type == 5)
      % sphere with three satellites
      m = [100 0.05 0.05 -0.43 -0.03 0;
        100 0.02 0.02 -0.53 0.04 0;
        100 0.02 0.02 -0.53 -0.10 0;
        100 0.02 0.02 -0.31 -0.03 0];
    elseif (type == 6)
      % disc and other sphere
      m = [100 0.08 0.08 -0.58 0.01 0;
        -100 0.05 0.05 -0.58 0.01 0;
        100 0.05 0.05 -0.25 -0.1 0];
    elseif (type == 7)
      % pins
      m = [100 0.025 0.025 -0.08 -0.03 0;
        100 0.025 0.025 -0.03 -0.25 0;
        100 0.025 0.025 -0.3 0.25 0;
        100 0.025 0.025 -0.2 0.25 0];
    end
    
    X = X + phantom(m,n);
    X(X>bone) = nmetal;
  end
  
end

% make sure the remainder is set to air
X(X==0) = air;
X = flipud(X);

return;