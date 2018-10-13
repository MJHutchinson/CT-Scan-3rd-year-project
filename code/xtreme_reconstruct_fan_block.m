raw_data = 'raw/raw_data_a.rsq';
out_dir = 'out/fdktest';
out_name = 'actionmanfdk';
out_file = strcat(out_dir , '/' , out_name);

studyUID = 'ActionManFDK';
seriesUID = '';

h = xtreme_get_rsq_header(raw_data);

slice_stop = 639;
slice_stop_recon = slice_stop - (floor(slice_stop/h.fan_scans) * 2 * h.skip_scans);

if(exist(out_dir, 'dir') ~= 7)
    error('Output directory does not exist')
end

run_time = tic;

recon = zeros(h.samples, h.samples, (ceil(slice_stop/h.fan_scans)*(h.fan_scans-2*h.skip_scans)));

total_fans = ceil(slice_stop/h.fan_scans);

for fan=1:min(total_fans, floor(h.scans/h.fan_scans))
    
    fprintf('======================================================\nNew Fan: %d\n\n', fan)
    fan_time = tic;
    
    fan_pos = (fan-1) * h.fan_scans + 1;
    
    if(fan_pos < slice_stop)
    
        recon_block = zeros(h.samples, h.samples, h.fan_scans - 2*h.skip_scans);

        data_block = zeros(h.recon_angles, h.samples, h.fan_scans);

        for g=1:(h.fan_scans)
            
            if(fan_pos + g <= h.scans)

                [slice, slice_min, slice_max] = xtreme_get_rsq_slice(h, fan_pos+g);

                slice = xtreme_calibrate(slice, slice_max, slice_min);

                slice = xtreme_fan_to_parallel(h, slice);

                slice = ramp_filter(slice, h.scale, 0.001); 

                data_block(:,:,g) = slice;
            
            end
            
        end

        width    = h.samples*h.scale;
        width_2  = (h.samples-1)/2 * h.scale;
        height_fan_origin   = h.fan_scans * h.scale;
        height_fan_origin_2 = (h.fan_scans-1)/2 * h.scale;
        heigh_layer_origin = (h.fan_scans - 2 * h.skip_scans) * h.scale;
        heigh_layer_origin_2 = (h.fan_scans -2 * h.skip_scans - 1)/2 * h.scale;

        [XX, YY, ZZ] = ndgrid(linspace(-width_2, width_2, h.samples), ...
                                linspace(-width_2, width_2, h.samples), ...
                                linspace(-height_fan_origin_2, height_fan_origin_2, h.fan_scans));

        [xx, yy, zz] = ndgrid(linspace(-width_2, width_2, h.samples), ...
                                linspace(-width_2, width_2, h.samples), ...
                                linspace(-heigh_layer_origin_2, heigh_layer_origin_2, h.fan_scans - 2*h.skip_scans));

        angle_time = tic;
        for a=1:h.recon_angles
            smear_block = data_block(a,:,:) .* ones(h.samples, 1, 1);

            p = pi/2+a*pi/h.recon_angles;
            xx_recon = xx*cos(p) - yy*sin(p);
            yy_recon = yy*cos(p) + xx * sin(p);

            zz_scale_factors = (xx_recon + h.radius)/h.radius;       

            zz_recon = zz./zz_scale_factors;

%             smear_function = griddedInterpolant(XX, YY, ZZ, smear_block, 'linear', 'none');
%             Y = smear_function(xx_recon, yy_recon, zz_recon);
            
            smear_function = griddedInterpolant(squeeze(YY(a,:,:)), squeeze(ZZ(a,:,:)), squeeze(data_block(a,:,:)), 'linear', 'none');
            Y = smear_function(yy_recon, zz_recon);
            
            Y(isnan(Y)) = 0;
            recon_block = recon_block + Y*(pi/h.recon_angles);

            if(mod(a, 10) == 0)
                fprintf(1, 'Angle %d \t\tTime Remaining %.2f \n', a, (toc(angle_time)/a) * ((total_fans-fan) * h.recon_angles + h.recon_angles-a))
            end
        end
        fprintf('Fan %d took %02g seconds\n\n', fan, toc(fan_time))
        
        recon_block = xtreme_hu(recon_block);

        recon(:,:,((fan-1)*(h.fan_scans-2*h.skip_scans)+1):((fan)*(h.fan_scans-2*h.skip_scans))) = recon_block;
    end
end
fprintf('Reconstruction took %04g seconds to do %d fans and %d slices\n', toc(run_time), floor(h.scans/h.fan_scans), size(recon, 3))


z=1;
for g=1:size(recon,3)
    if (g<=slice_stop_recon)
            create_dicom(recon(:,:,g), 'out/fdktest/actionmanfdk', h.scale, h.scale, z, studyUID, seriesUID);
%                 increment z
            z = z + 1;
    end
end