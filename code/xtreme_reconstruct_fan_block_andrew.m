ha = xtreme_get_rsq_header('raw_data_b.rsq');
starting_fan = 3*ha.fan_scans+1;
for f=starting_fan:ha.fan_scans:ha.scans 
    fan = tic;
    fprintf('======================================================\nNew Fan: %d\n\n', ceil((f+ha.fan_scans)/ha.fan_scans))
    recon_block = zeros(ha.samples, ha.samples, ha.fan_scans - 2*ha.skip_scans);
    
    data_block = zeros(ha.recon_angles, ha.samples, ha.fan_scans);
    
    for g=1:(ha.fan_scans)
        [slice, slice_min, slice_max] = xtreme_get_rsq_slice(ha, f+g);
        
        slice = ct_calibrate(slice_min, slice_max, slice);
        
        slice = xtreme_fan_to_parallel(ha, slice);
        
        slice = xtreme_ramp_filter(slice, ha.scale, 'Shepp-Logan', 2); 
        
        data_block(:,:,g) = slice;
    end
    
    width    = ha.samples*ha.scale;
    width_2  = (ha.samples-1)/2 * ha.scale;
    height_fan_origin   = ha.fan_scans * ha.scale;
    height_fan_origin_2 = (ha.fan_scans-1)/2 * ha.scale;
    heigh_layer_origin = (ha.fan_scans - 2 * ha.skip_scans) * ha.scale;
    heigh_layer_origin_2 = (ha.fan_scans -2 * ha.skip_scans - 1)/2 * ha.scale;
    
    [XX, YY, ZZ] = ndgrid(linspace(-width_2, width_2, ha.samples), ...
                            linspace(-width_2, width_2, ha.samples), ...
                            linspace(-height_fan_origin_2, height_fan_origin_2, ha.fan_scans));
                        
    [xx, yy, zz] = ndgrid(linspace(-width_2, width_2, ha.samples), ...
                            linspace(-width_2, width_2, ha.samples), ...
                            linspace(-heigh_layer_origin_2, heigh_layer_origin_2, ha.fan_scans - 2*ha.skip_scans));
    
    zz_scale_factors = (xx + ha.radius)/ha.radius;       
    
    zz_transform = zz./zz_scale_factors;
                        
    angle = tic;
    for a=1:ha.recon_angles        
        p = pi/2+a*pi/ha.recon_angles;
        yy_recon = yy*cos(p) + xx * sin(p);
        
        p = griddedInterpolant(squeeze(YY(a,:,:)), squeeze(ZZ(a,:,:)), squeeze(data_block(a,:,:)), 'linear', 'none');
        
        Y = p(yy_recon, zz_transform);
        
        Y(isnan(Y)) = 0;
        recon_block = recon_block + Y*(pi/ha.recon_angles);
        fprintf('Angle %d \t\tTime Remaining %f\n', a, toc(angle)/(a/ha.recon_angles))
        draw(recon_block(:,:,1)); pause(0.01)
    end
    
    fprintf('Fan %d took %04g seconds\n\n\n\n', ceil((f+ha.fan_scans)/ha.fan_scans), toc(fan))
end