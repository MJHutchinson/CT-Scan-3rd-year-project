function xtreme_reconstruct_continuous(ha, hb, file, alpha)

%
STUDYUID  =  'ActionManNoParallel';
SERIESUID =  'Whole';
%

a_stop = 639;
b_stop = 560;

a_start = 0;
b_start = 0;

z = 1;

% loop over each z-fan
fprintf(1, 'Reconstructing, slice:   0');

fprintf(1, 'b\n')
for f=1:hb.fan_scans:hb.scans    
    % default method should reconstruct each slice separately
    for g=(f+hb.skip_scans):(f+hb.fan_scans-hb.skip_scans-1)
        if ((g<=b_stop) && (g>= b_start))
%             fprintf(1, '%i\n', g)
            
            fprintf(1, '\b\b\b\b%4i',z);

            slice = xtreme_reconstruct_slice(hb, g, alpha);

            slice = flip(slice, 2);

            create_dicom(slice, file, hb.scale, hb.scale, z, 'ActionManNoParallel', 'Whole');

%             increment z
            z = z + 1;

        end
    end   
end

fprintf(1, 'a\n')
for f=flip(1:ha.fan_scans:ha.scans)    
    % default method should reconstruct each slice separately
    for g=(f+ha.fan_scans-ha.skip_scans-1):-1:(f+ha.skip_scans)
        if ((g<=a_stop) && (g>= a_start))
%             fprintf(1, '%i\n', g)

            fprintf(1, '\b\b\b\b%4i',z);

            slice = xtreme_rotate_translate(xtreme_reconstruct_slice(ha, g, alpha), 1.95, [1;0], [-0.01;-0.01]);

%             slice = flip(slice, 2);

            create_dicom(slice, file, ha.scale, ha.scale, z, 'ActionManNoParallel', 'Whole');

            % increment z
            z = z + 1;

        end
    end   
end

fprintf(1, '\n');


end

