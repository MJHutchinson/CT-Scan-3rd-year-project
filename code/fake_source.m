function [Y] = fake_source(mev, mvp, coeffs, t, method)

% FAKE_SOURCE generate typical CT X-ray source energies
%
%  Y = FAKE_SOURCE((mev, mvp, coeffs, t) creates a vector Y of photons per
%  cm^2 per keV, at the energies given by the vector mev and for a source
%  with the given mvp maximum energy in MeV.
%
%  The source will be filtered by a thickness t (in mm) of the material
%  whose mass attenuation coefficients are given by coeffs, which are
%  presumed to be at the same set of energies as given in mev.
%
%  Y = FAKE_SOURCE(mev, mvp, coeffs, t, 'ideal') creates output energies
%  for an 'ideal' source with a very narrow energy range.

% check inputs
narginchk(4,5);
if (nargin<5)
  method = 'normal';
end

if (strcmp(method,'ideal'))
  
  % single energy, at about the peak of the broader energy radiation
  Y = zeros(size(mev));
  Y(abs(mev-mvp*0.7)<0.001) = 1e10;
  
else
  
  % experimental function to match expected form of source radiation
  alpha = 100;
  sigma = mvp/2;
  offset = -sigma;
  Y = (1/(2*pi).^2)*exp(-((mev-offset).^2)/(2*sigma^2)) .*abs(mev-offset).^(1/alpha);
  Y(mev>mvp)=0;
  Y(mev>(0.8*mvp)) = Y(mev>(0.8*mvp)).*((mvp-mev(mev>(0.8*mvp)))/(0.2*mvp)).^0.3;
  Y = Y*1.5e9;
  
end

% add any additional metal filter
Y = Y.*exp(-coeffs*t/10);
