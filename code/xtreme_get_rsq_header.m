function [h] = xtreme_get_rsq_header( filename )

% XTREME_GET_RSQ_HEADER get information about rsq file
%
%  h = XTREME_GET_RSQ_HEADER( filename ) reads the Xtreme scanner .RSQ file
%  specified by filename, and returns a header structure with information
%  about that file. The structure contains the following fields:
%
%    'scans' - number of scans (z-axis locations), inclusing overlapping
%                 scans
%    'angles' - total number of angles (x-y plane rotations, at each z-axis
%                  location)
%    'samples' - number of samples (at each rotational angle, and in each
%                     z-axis location)
%    'skip_scans' - number of scans at each end of each z-fan
%                        which overlap with the neighbouring z-fan
%    'skip_angles' - number of rotational angles in a full rotation which
%                         are additional to the required fan rotation
%    'skip_samples' - number of samples at the start of each line which are
%                            invalid and not read in from the file
%    'fan_scans' - number of z-axis scans in each z-fan group
%    'fan_angles' - number of rotational angles which correspond to a
%                        single (x-y plane) fan
%    'recon_angles' - number of rotational angles in 180 degrees
%    'dtheta' - angle between each measurement, in radians
%    'fan_theta' - x-y plane fan angle, in radians
%    'radius' - distance from X-ray source to centre of rotation, expressed
%                  in terms of numbers of samples
%    'scale' - pixel size and z-increment, in mm
%    'data_offset' - internal offset used for reading data from file
%    'filename' - name of file
%
%  The structure h can be passed to the other xtreme functions to read the
%  raw data from the file.

% check inputs
narginchk(1,1);

% try to open the file
fid = fopen(filename, 'r');
if (fid == -1)
  error('File "%s" not found', filename);
end

% check it starts the way we would expect
type = fread(fid, 16, 'uchar');
if (~strncmp(char(type), 'CTDATA-HEADER_V1', 16))
  fclose(fid);
  error('This file is not an Xtreme RSQ file');
end

% now read in the data and form the output structure
% 8: dimx_p
% 9: dimy_p
% 10: dimz_p
% 15: slice_increment_um
% 20: nr_of_samples
% 21: nr_of_projections
% 124: data_offset
header = fread(fid, 124, 'int32');
res = header(20)/header(8);
skip_samples = floor(30/res);

h = struct();

h.scans = header(10);  % number of scans
h.angles = header(9) - 2; % number of angles in each total sweep
h.samples = header(8) - skip_samples; % number of sample measurements at each angle

h.skip_scans = floor(18/res);
h.skip_angles = 2*floor(9/res);
h.skip_samples = skip_samples;

h.fan_scans = floor(header(21)/res);
h.fan_angles = floor(168/res - h.skip_angles);
h.recon_angles = (h.angles - h.skip_angles - h.fan_angles);
h.dtheta = (pi/h.recon_angles);
h.fan_theta = h.dtheta * h.fan_angles;

h.radius = (h.samples/2)/tan(h.fan_theta/2);
h.scale = 0.00104*header(15);

h.data_offset = header(124);
h.filename = filename;

fclose(fid);
