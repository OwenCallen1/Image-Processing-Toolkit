function output = separable_filter_reflect(image, verticalKernel, horizontalKernel)
%SEPARABLE_FILTER_REFLECT Filter horizontally and vertically with reflection.
verticalKernel = verticalKernel(:);
horizontalKernel = horizontalKernel(:).';
if mod(numel(verticalKernel), 2) == 0 || mod(numel(horizontalKernel), 2) == 0
    error("DIPToolkit:EvenKernel", "Separable kernels must have odd lengths.");
end
[rows, columns] = size(image);
horizontalRadius = floor(numel(horizontalKernel) / 2);
verticalRadius = floor(numel(verticalKernel) / 2);
temporary = zeros(rows, columns);
output = zeros(rows, columns);
for column = 1:columns
    indices = reflect_index(column + (-horizontalRadius:horizontalRadius), columns);
    temporary(:, column) = image(:, indices) * fliplr(horizontalKernel).';
end
for row = 1:rows
    indices = reflect_index(row + (-verticalRadius:verticalRadius), rows);
    output(row, :) = flipud(verticalKernel).' * temporary(indices, :);
end
end
