function metrics = evaluate_outputs(outputs, inputImage, reference)
%EVALUATE_OUTPUTS Compute dependency-free MSE, PSNR, and global SSIM.
if isempty(reference)
    reference = inputImage;
    referenceLabel = "input";
else
    referenceLabel = "reference";
end
names = fieldnames(outputs);
metrics = struct();
for i = 1:numel(names)
    candidate = outputs.(names{i});
    errorImage = candidate - reference;
    mse = mean(errorImage(:).^2);
    if mse == 0
        psnrValue = Inf;
    else
        psnrValue = 10 * log10(1 / mse);
    end
    metrics.(names{i}) = struct("comparedTo", referenceLabel, ...
        "mse", mse, "psnrDb", psnrValue, ...
        "globalSsim", global_ssim(candidate, reference));
end
end

function value = global_ssim(a, b)
c1 = 0.01^2;
c2 = 0.03^2;
meanA = mean(a(:));
meanB = mean(b(:));
varianceA = mean((a(:) - meanA).^2);
varianceB = mean((b(:) - meanB).^2);
covariance = mean((a(:) - meanA) .* (b(:) - meanB));
value = ((2 * meanA * meanB + c1) * (2 * covariance + c2)) / ...
    ((meanA^2 + meanB^2 + c1) * (varianceA + varianceB + c2));
end
