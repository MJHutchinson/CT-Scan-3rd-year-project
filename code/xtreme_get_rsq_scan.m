function [Y, Ymin, Ymax] = xtreme_get_rsq_scan(h, A)


% XTREME_GET_RSQ_SCAN read X-ray scan from rsq file
%
%  [Y, Ymin, Ymax] = XTREME_GET_RSQ_SCAN(h, A) uses the structure in h
%  (returned from XTREME_GET_RSQ_HEADER) to read in angle A from the rsq
%  file.
%
%  The returned data Y is effectively an X-ray at angle A, except that
%  every slice is included, despite the raw data being split into z-fans of
%  h.fan_scans size each. Hence Y is of size (h.scans x h.samples). Ymin
%  are the recorded detections when there is no X-ray source, and Ymax are
%  the recorded detections when there is no object in the scanner.

% check inputs
narginchk(2,2);

% check input is within range
if (A>h.angles)
  error('File only contains %i angles', h.angles);
end

% Open file and find start of data
fid = fopen(h.filename);
fseek(fid, (h.data_offset+1)*512, 'cof');

% loop through scans, selecting appropriate angle, and all calibration data
for i=[1:h.scans]
  fseek(fid, h.skip_samples*2, 'cof');
  Ymin(i,:) = fread(fid, h.samples, 'int16');
  fseek(fid, h.skip_samples*2, 'cof');
  Ymax(i,:) = fread(fid, h.samples, 'int16');

   fseek(fid, (h.samples+h.skip_samples)*(A-1)*2, 'cof');
   fseek(fid, h.skip_samples*2, 'cof');
   Y(i,:) = fread(fid, h.samples, 'int16');
   fseek(fid, (h.samples+h.skip_samples)*(h.angles-A)*2, 'cof');
end
  
fclose(fid);
