function [Y] = xtreme_reconstruct_slice(h, slice,ALPHA)
        [slice, slice_min, slice_max] = xtreme_get_rsq_slice(h, slice);
        
        slice = xtreme_calibrate(slice, slice_max, slice_min);
        
        slice = xtreme_fan_to_parallel(h, slice);
        
        slice = ramp_filter(slice, h.scale, ALPHA, 1);
        
        recon = back_project(slice);
        
        Y = xtreme_hu(recon);
end

