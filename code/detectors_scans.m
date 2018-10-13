hip_32 = ct_phantom(material.name, 32, 3, 'Titanium');
hip_64 = ct_phantom(material.name, 64, 3, 'Titanium');
hip_128 = ct_phantom(material.name, 128, 3, 'Titanium');
hip_512 = ct_phantom(material.name, 512, 3, 'Titanium');

[hip_recon_size_32,a,a,a]= scan_and_reconstruct(hundredkv1al, material, hip_32, 0.1 * 256/32, 256);
[hip_recon_size_64,a,a,a]= scan_and_reconstruct(hundredkv1al, material, hip_64, 0.1 * 256/64, 256);
[hip_recon_size_128,a,a,a]= scan_and_reconstruct(hundredkv1al, material, hip_128, 0.1 * 256/128, 256);
[hip_recon_size_512,a,a,a]= scan_and_reconstruct(hundredkv1al, material, hip_512, 0.1 * 256/512, 256);

