load ct_data.mat
make_phantoms
[reconstruction, a, a, a] = scan_reconstruct_plot(source.photons(:,1), material, hip, 0.1, 256, 1000);
draw_dynamic(reconstruction, 2);