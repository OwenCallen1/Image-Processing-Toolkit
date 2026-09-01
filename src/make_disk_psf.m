function kernel = make_disk_psf(radius, kernelSize)
%MAKE_DISK_PSF Construct a normalized circular, uniform PSF.
validateattributes(radius, {'numeric'}, {'scalar', 'positive'});
validateattributes(kernelSize, {'numeric'}, {'scalar', 'integer', 'positive'});
if mod(kernelSize, 2) == 0
    error("DIPToolkit:EvenKernel", "Kernel size must be odd.");
end
half = floor(kernelSize / 2);
if radius > half
    error("DIPToolkit:DiskRadius", "Radius must fit inside the kernel.");
end
[x, y] = meshgrid(-half:half, -half:half);
kernel = double(x.^2 + y.^2 <= radius^2);
kernel = kernel / sum(kernel(:));
end
