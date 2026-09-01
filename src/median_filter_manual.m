function output = median_filter_manual(image, windowSize)
%MEDIAN_FILTER_MANUAL Apply an odd-window median filter with reflection.
validateattributes(image, {'numeric'}, {'2d', 'real', 'finite', 'nonempty'});
validateattributes(windowSize, {'numeric'}, {'scalar', 'integer', 'positive'});
if mod(windowSize, 2) == 0
    error("DIPToolkit:EvenWindow", "Median window size must be odd.");
end
[rows, columns] = size(image);
radius = floor(windowSize / 2);
output = zeros(rows, columns);
for row = 1:rows
    rowIndices = reflect_index(row + (-radius:radius), rows);
    for column = 1:columns
        columnIndices = reflect_index(column + (-radius:radius), columns);
        neighborhood = image(rowIndices, columnIndices);
        output(row, column) = median(neighborhood(:));
    end
end
end
