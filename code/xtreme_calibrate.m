function [scan] = xtreme_calibrate(scan, scan_max, scan_min)

    scan_max = scan_max - scan_min;
    
    scan_min = ones(size(scan, 1), 1) * scan_min;
    
    scan     = scan - scan_min;

    scan_max = ones(size(scan, 1), 1) * scan_max;
        
    scan     = -log(scan ./ scan_max);

end

