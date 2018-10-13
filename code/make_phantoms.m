% Simple script to make phantoms of each possible type, with a given metal
% and number of beams

metal = "Titanium";
size = 256;
circle = ct_phantom(material.name, size, 1, metal);
point = ct_phantom(material.name, size, 2, metal);
hip = ct_phantom(material.name, size, 3, metal);
dual_hip = ct_phantom(material.name, size, 4, metal);
sphere = ct_phantom(material.name, size, 5, metal);
disc = ct_phantom(material.name, size, 6, metal);
pelvic_pins = ct_phantom(material.name, size, 7, metal);

% Also make a water circle, useful for a few things
water_circle = ct_phantom(material.name, size, 1, 'Water');