function xtreme_reconstruct_all(h, FILENAME, ALPHA, METHOD)

% XTREME_RECONSTRUCT_ALL Create DICOM data from Xtreme RSQ file
%
%  XTREME_RECONSTRUCT_ALL(H, FILENAME, ALPHA) creates a series of DICOM
%  files for the Xtreme RSQ data given in the structure H. FILENAME is the
%  base file name for the data, and ALPHA is the power of the raised cosine
%  function used to filter the data.
%
%  XTREME_RECONSTRUCT_ALL(H, FILENAME, ALPHA, METHOD) can be used to
%  specify how the data is reconstructed. Possible options are:
%
%    'parallel' - reconstruct each slice separately using a fan to parallel
%                   conversion
%    'fdk' - approximate FDK algorithm for better reconstruction

% check inputs
narginchk(3,4);
if (nargin<4)
  METHOD = 'parallel';
end

% set frame number and DICOM UIDs for saving to multiple frames
z = 1;
seriesuid = dicomuid();
studyuid = dicomuid();
datetime = now();

% loop over each z-fan
fprintf(1, 'Reconstructing, slice:   0');
for f=1:h.fan_scans:h.scans
  
  if (strcmp(METHOD,'fdk'))
    
    % correct reconstruction using FDK method would need to use all
    % h.fan_scans at once
    
  else
    
    % default method should reconstruct each slice separately
    for g=(f+h.skip_scans):(f+h.fan_scans-h.skip_scans-1)
      if (g<=h.scans)
        fprintf(1, '\b\b\b\b%4i',g);
        
        
        % reconstruct scan g
        [slice, slice_min, slice_max] = xtreme_get_rsq_slice(h, g);
        
        slice = xtreme_calibrate(slice, slice_max, slice_min);
        
        parallel_slice = xtreme_fan_to_parallel(h, slice);
        
        parallel_slice = ramp_filter(parallel_slice, h.scale, ALPHA);
        
        recon = back_project(parallel_slice);

        recon = xtreme_hu(recon, h.scale);

        create_dicom(recon, FILENAME, h.scale, h.scale, z, 'ActionMan', 'Lower');
                
        % increment z
        z = z + 1;
        
      end
    end
    
  end
   
end
fprintf(1, '\n');
