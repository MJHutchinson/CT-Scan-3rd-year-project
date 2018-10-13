total_time = tic;

ha = xtreme_get_rsq_header('raw/raw_data_a.rsq');
hb = xtreme_get_rsq_header('raw/raw_data_b.rsq');

studyUID = 'ActionManPFDK-3';
seriesUID = 'Whole';

out_dir = 'out/pfdk3';
out_name = 'actionman_pdfk3';
out_file = strcat(out_dir , '/' , out_name);

if(exist(out_dir, 'dir') ~= 7)
    mkdir(out_dir)
end

a_stop = 638;
b_stop = 560;

a_stop_recon = a_stop - floor(a_stop/ha.fan_scans)*2*ha.skip_scans - ha.skip_scans;
b_stop_recon = b_stop - floor(b_stop/hb.fan_scans)*2*hb.skip_scans - ha.skip_scans;

a_rotate_angle = -2.7;
a_rotate_centre = [0.5;0.5];
a_translate = [-0.007;0.002];

filter_alpha = 0.001;

recon_block_a = xtreme_reconstruct_p_fdk(ha, a_stop, filter_alpha);
recon_block_b = xtreme_reconstruct_p_fdk(hb, b_stop, filter_alpha);

% z=1;
% for g=1:b_stop_recon
%         slice = recon_block_b(:,:,g);
%         slice = flip(slice, 2);
%         create_dicom(slice, out_file, hb.scale, hb.scale, z, studyUID, seriesUID);
%         z = z + 1;
% end   
% 
% for g=a_stop_recon:-1:1
%         slice = recon_block_a(:,:,g);
%         slice = xtreme_rotate_translate(slice, a_rotate_angle, a_rotate_centre, a_translate);
%         create_dicom(slice, out_file, ha.scale, ha.scale, z, studyUID, seriesUID);
%         z = z + 1;
% end    

fprintf('Total process took %02g seconds\n\n', toc(total_time));