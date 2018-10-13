hc = xtreme_get_rsq_header('raw/test_object_data.rsq');

studyUID = 'Calibration-PFDK';
seriesUID = 'Whole';

out_dir = 'out/calibration';
out_name = 'calibration';
out_file = strcat(out_dir , '/' , out_name);

if(exist(out_dir, 'dir') ~= 7)
    mkdir(out_dir)
end

% recon_block_test = xtreme_reconstruct_p_fdk(hc, 324, 0.001);
z=1;
for g=1:size(recon_block_test,3)
        slice = recon_block_test(:,:,g);
        create_dicom(slice, out_file, ha.scale, ha.scale, z, studyUID, seriesUID);
        z = z + 1;
end   