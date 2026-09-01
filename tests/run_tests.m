%RUN_TESTS Numerical smoke and regression tests for the toolkit.
rootDir = fileparts(fileparts(mfilename("fullpath")));
addpath(rootDir, fullfile(rootDir, "src"));
rng(1, "twister");

constant = 0.37 * ones(9, 13);
assert(max(abs(median_filter_manual(constant, 5) - constant), [], "all") < 1e-12);
assert(max(abs(knn_mean_filter(constant, 3, 4, true) - constant), [], "all") < 1e-12);

disk = make_disk_psf(3, 11);
gaussian = gaussian_kernel_1d(2, []);
assert(abs(sum(disk(:)) - 1) < 1e-12);
assert(abs(sum(gaussian) - 1) < 1e-12);
assert(max(abs(convolve2_reflect(constant, disk) - constant), [], "all") < 1e-12);
assert(max(abs(separable_filter_reflect(constant, gaussian, gaussian) - constant), [], "all") < 1e-12);

image = rand(8, 10);
defaults = default_config();
cfg = defaults.frequency;
cfg.lowGain = 1;
cfg.highGain = 1;
[fftOutput, ~, ~, mask] = frequency_high_emphasis(image, cfg);
assert(max(abs(fftOutput - image), [], "all") < 1e-12);
assert(all(mask(:) == 1));
cfg.method = "matrix";
[matrixOutput, matrixSpectrum] = frequency_high_emphasis(image, cfg);
assert(max(abs(matrixOutput - image), [], "all") < 1e-11);
assert(max(abs(matrixSpectrum - fft2(image)), [], "all") < 1e-10);

transforms = linear_transform_demo([5 7], 457);
assert(transforms.errors.separableMaxAbs < 1e-12);
assert(transforms.errors.circularVsFFTMaxAbs < 1e-10);
assert(transforms.errors.separableCircularMaxAbs < 1e-10);

disp("All Digital Image Processing Toolkit tests passed.");
