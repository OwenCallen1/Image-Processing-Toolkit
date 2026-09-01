function demo = linear_transform_demo(imageSize, randomSeed)
%LINEAR_TRANSFORM_DEMO Demonstrate and verify four linear-transform classes.
validateattributes(imageSize, {'numeric'}, {'vector', 'numel', 2, 'integer', 'positive'});
rng(randomSeed, "twister");
rows = imageSize(1);
columns = imageSize(2);
image = rand(rows, columns);

operator = rand(rows, columns, rows, columns);
general = zeros(rows, columns);
for outputRow = 1:rows
    for outputColumn = 1:columns
        weights = operator(:, :, outputRow, outputColumn);
        general(outputRow, outputColumn) = sum(weights .* image, "all");
    end
end

left = rand(rows, rows);
right = rand(columns, columns);
separableTwoPass = left * (image * right);
separableReference = left * image * right;

circularKernel = rand(rows, columns);
circular = circular_convolution(image, circularKernel);
circularReference = real(ifft2(fft2(image) .* fft2(circularKernel)));

verticalKernel = rand(rows, 1);
horizontalKernel = rand(1, columns);
separableCircular = separable_circular_convolution( ...
    image, verticalKernel, horizontalKernel);
fullKernel = verticalKernel * horizontalKernel;
separableCircularReference = circular_convolution(image, fullKernel);

demo = struct();
demo.input = image;
demo.outputs = struct("general", general, "separable", separableTwoPass, ...
    "circular", circular, "separableCircular", separableCircular);
demo.errors = struct( ...
    "separableMaxAbs", max(abs(separableTwoPass - separableReference), [], "all"), ...
    "circularVsFFTMaxAbs", max(abs(circular - circularReference), [], "all"), ...
    "separableCircularMaxAbs", max(abs(separableCircular - separableCircularReference), [], "all"));
end

function output = separable_circular_convolution(image, verticalKernel, horizontalKernel)
[rows, columns] = size(image);
temporary = zeros(rows, columns);
output = zeros(rows, columns);
for row = 1:rows
    for outputColumn = 1:columns
        total = 0;
        for inputColumn = 1:columns
            kernelColumn = mod(outputColumn - inputColumn, columns) + 1;
            total = total + horizontalKernel(kernelColumn) * image(row, inputColumn);
        end
        temporary(row, outputColumn) = total;
    end
end
for outputRow = 1:rows
    for column = 1:columns
        total = 0;
        for inputRow = 1:rows
            kernelRow = mod(outputRow - inputRow, rows) + 1;
            total = total + verticalKernel(kernelRow) * temporary(inputRow, column);
        end
        output(outputRow, column) = total;
    end
end
end

function output = circular_convolution(image, kernel)
[rows, columns] = size(image);
[kernelRows, kernelColumns] = size(kernel);
output = zeros(rows, columns);
for outputRow = 1:rows
    for outputColumn = 1:columns
        total = 0;
        for inputRow = 1:rows
            kernelRow = mod(outputRow - inputRow, kernelRows) + 1;
            for inputColumn = 1:columns
                kernelColumn = mod(outputColumn - inputColumn, kernelColumns) + 1;
                total = total + kernel(kernelRow, kernelColumn) * image(inputRow, inputColumn);
            end
        end
        output(outputRow, outputColumn) = total;
    end
end
end
