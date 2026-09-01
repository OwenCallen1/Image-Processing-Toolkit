function output = convolve2_reflect(image, kernel)
%CONVOLVE2_REFLECT Direct 2-D convolution using reflected boundaries.
validateattributes(image, {'numeric'}, {'2d', 'real', 'finite', 'nonempty'});
validateattributes(kernel, {'numeric'}, {'2d', 'real', 'finite', 'nonempty'});
[kernelRows, kernelColumns] = size(kernel);
if mod(kernelRows, 2) == 0 || mod(kernelColumns, 2) == 0
    error("DIPToolkit:EvenKernel", "Kernel dimensions must be odd.");
end
[rows, columns] = size(image);
rowRadius = floor(kernelRows / 2);
columnRadius = floor(kernelColumns / 2);
output = zeros(rows, columns);
flipped = rot90(kernel, 2);
for row = 1:rows
    rowIndices = reflect_index(row + (-rowRadius:rowRadius), rows);
    for column = 1:columns
        columnIndices = reflect_index(column + (-columnRadius:columnRadius), columns);
        patch = image(rowIndices, columnIndices);
        output(row, column) = sum(patch .* flipped, "all");
    end
end
end
