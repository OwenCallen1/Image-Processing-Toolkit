%RUN_DEMO Generate a noisy test image and exercise the complete toolkit.
rootDir = fileparts(fileparts(mfilename("fullpath")));
addpath(rootDir);

rng(457, "twister");
imageSize = 128;
[x, y] = meshgrid(linspace(-1, 1, imageSize));
clean = 0.15 + 0.55 * exp(-4 * (x.^2 + y.^2));
clean = clean + 0.20 * (x > -0.75 & x < -0.15 & y > -0.60 & y < 0.25);
clean = min(max(clean, 0), 1);
noisy = clean + 0.04 * randn(size(clean));
saltPepper = rand(size(clean));
noisy(saltPepper < 0.02) = 0;
noisy(saltPepper > 0.98) = 1;
noisy = min(max(noisy, 0), 1);

assetDir = fullfile(rootDir, "examples", "generated");
if ~isfolder(assetDir)
    mkdir(assetDir);
end
inputPath = fullfile(assetDir, "noisy_input.png");
referencePath = fullfile(assetDir, "clean_reference.png");
imwrite(noisy, inputPath);
imwrite(clean, referencePath);

cfg = default_config();
cfg.inputPath = inputPath;
cfg.referencePath = referencePath;
cfg.outputDir = fullfile(rootDir, "results", "demo");
cfg.showFigures = true;
results = run_toolkit(cfg);
disp(results.metrics);
