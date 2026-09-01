function [output, inputSpectrum, filteredSpectrum, mask] = frequency_high_emphasis(image, cfg)
%FREQUENCY_HIGH_EMPHASIS Apply a radial, smooth high-emphasis filter.
[rows, columns] = size(image);
method = string(cfg.method);
if method == "matrix"
    if max(rows, columns) > cfg.matrixMaxDimension
        error("DIPToolkit:MatrixDFTSize", ...
            "Matrix DFT dimension exceeds matrixMaxDimension (%d).", cfg.matrixMaxDimension);
    end
    [inputSpectrum, rowMatrix, columnMatrix] = explicit_dft2(image);
else
    inputSpectrum = fft2(image);
end

[x, y] = meshgrid((-floor(columns/2)):(ceil(columns/2)-1), ...
    (-floor(rows/2)):(ceil(rows/2)-1));
radius = hypot(x, y);
nyquistRadius = min(rows, columns) / 2;
cutoff = cfg.cutoffFraction * nyquistRadius;
transition = cfg.transitionFraction * nyquistRadius;
weight = double(radius >= cutoff);
if transition > 0
    lower = max(0, cutoff - transition / 2);
    upper = cutoff + transition / 2;
    weight(radius <= lower) = 0;
    weight(radius >= upper) = 1;
    band = radius > lower & radius < upper;
    weight(band) = 0.5 - 0.5 * cos(pi * (radius(band) - lower) / (upper - lower));
end
maskCentered = cfg.lowGain + (cfg.highGain - cfg.lowGain) * weight;
mask = ifftshift(maskCentered);
filteredSpectrum = inputSpectrum .* mask;
if method == "matrix"
    output = real((conj(rowMatrix) / rows) * filteredSpectrum * ...
        (conj(columnMatrix) / columns));
else
    output = real(ifft2(filteredSpectrum));
end
output = min(max(output, 0), 1);
end

function [spectrum, rowMatrix, columnMatrix] = explicit_dft2(image)
[rows, columns] = size(image);
rowIndices = 0:rows-1;
columnIndices = 0:columns-1;
rowMatrix = exp(-1i * 2 * pi * (rowIndices.' * rowIndices) / rows);
columnMatrix = exp(-1i * 2 * pi * (columnIndices.' * columnIndices) / columns);
spectrum = rowMatrix * image * columnMatrix;
end
