function [Y, Ymin, Ymax] = xtreme_get_rsq_slice(h, F)

% XTREME_GET_RSQ_SLICE read slice from rsq file
%
%  [Y, Ymin, Ymax] = XTREME_GET_RSQ_SLICE(h, F) uses the structure in h
%  (returned from XTREME_GET_RSQ_HEADER) to read in slice F from the rsq
%  file.
%
%  The returned data Y is a fan-based sinogram of size (h.angles x
%  h.samples), Ymin are the recorded detections when there is no X-ray
%  source, and Ymax are the recorded detections when there is no object in
%  the scanner.

% check inputs
narginchk(2,2);

% check input is within range
if (F>h.scans)
  error('File only contains %i scans', h.scans);
end

% Open file and find start of data
fid = fopen(h.filename);
fseek(fid, (h.data_offset+1)*512, 'cof');

% skip to requested slice
fseek(fid, (h.samples+h.skip_samples)*(h.angles+2)*2*(F-1), 'cof');

% read in calibrations for this slice
fseek(fid, h.skip_samples*2, 'cof');
Ymin = fread(fid, h.samples, 'int16')';
fseek(fid, h.skip_samples*2, 'cof');
Ymax = fread(fid, h.samples, 'int16')';

% read in remainder of data
for a=[1:h.angles]
  fseek(fid, h.skip_samples*2, 'cof');
  Y(a,:) = fread(fid, h.samples, 'int16');
end
  
fclose(fid);
