function kernel = gaussian_kernel_1d(sigma, radius)
%GAUSSIAN_KERNEL_1D Construct a normalized 1-D Gaussian kernel.
validateattributes(sigma, {'numeric'}, {'scalar', 'positive'});
if nargin < 2 || isempty(radius)
    radius = ceil(3 * sigma);
end
validateattributes(radius, {'numeric'}, {'scalar', 'integer', 'positive'});
x = -radius:radius;
kernel = exp(-(x.^2) / (2 * sigma^2));
kernel = kernel / sum(kernel);
end
