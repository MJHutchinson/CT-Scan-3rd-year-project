function [recon] = xtreme_reconstruct_p_fdk(h, slice_stop, alpha)

    run_time = tic;

    scale                = h.scale;
    radius               = h.radius * h.scale;
    samples              = h.samples;
    scans                = h.scans;
    fan_scans            = h.fan_scans;
    fan_recon_scans      = h.fan_scans - 2*h.skip_scans;
    recon_angles         = h.recon_angles;
    width_2              = (h.samples-1)/2 * h.scale;
    height_fan_origin_2  = (h.fan_scans-1)/2 * h.scale;
    heigh_layer_origin_2 = (h.fan_scans -2 * h.skip_scans - 1)/2 * h.scale;
    
    [YY, ZZ] = ndgrid(...
                                    linspace(-width_2, width_2, samples), ...
                                    linspace(-height_fan_origin_2, height_fan_origin_2, fan_scans));

    [xx, yy, zz] = ndgrid(linspace(-width_2, width_2, h.samples), ...
                            linspace(-width_2, width_2, h.samples), ...
                            linspace(-heigh_layer_origin_2, heigh_layer_origin_2, fan_recon_scans));

    recon = zeros(samples, samples, (ceil(slice_stop/fan_scans)*(fan_recon_scans)));

    total_fans = ceil(slice_stop/fan_scans);

    for fan=1:min(total_fans, floor(scans/fan_scans))

        fprintf('======================================================\nNew Fan: %d\n\n', fan)
        fan_time = tic;

        fan_pos = (fan-1) * fan_scans + 1;

        if(fan_pos < slice_stop)

            recon_block = zeros(samples, samples, fan_recon_scans);

            data_block = zeros(recon_angles, samples, fan_scans);

            for g=1:(fan_scans)

                if(fan_pos + g <= scans)

                    [slice, slice_min, slice_max] = xtreme_get_rsq_slice(h, fan_pos+g);

                    slice = xtreme_calibrate(slice, slice_max, slice_min);

                    slice = xtreme_fan_to_parallel(h, slice);

                    slice = ramp_filter(slice, scale, alpha); 

                    data_block(:,:,g) = slice;

                end

            end

            angle_time = tic;
            for a=1:h.recon_angles

                p = pi/2 + a*pi/recon_angles;
                tt = xx*cos(p) - yy*sin(p);
                vv = yy*cos(p) + xx * sin(p);
                
                dist_to_source = sqrt(radius.^2 -tt.^2);

                zz_scale_factors = (vv + dist_to_source)./dist_to_source;       

                ss = zz./zz_scale_factors;
                
                smear_function = griddedInterpolant(squeeze(YY), squeeze(ZZ), squeeze(data_block(a,:,:)), 'linear', 'none');
                Y = smear_function(tt, ss);

                Y(isnan(Y)) = 0;
                recon_block = recon_block + Y*(pi/h.recon_angles);

                if(mod(a, 10) == 0)
                    fprintf(1, 'Angle %d \t\tTime Remaining %.2f \n', a, (toc(angle_time)/a) * ((total_fans-fan) * h.recon_angles + h.recon_angles-a))
                end
                
            end
            fprintf('Fan %d took %02g seconds\n\n', fan, toc(fan_time))

            recon_block = xtreme_hu(recon_block);

            recon(:,:,((fan-1)*(h.fan_scans-2*h.skip_scans)+1):((fan)*(fan_recon_scans))) = recon_block;
        end
    end
    fprintf('Reconstruction took %04g seconds to do %d fans and %d slices\n', toc(run_time), floor(h.scans/h.fan_scans), size(recon, 3))

end

