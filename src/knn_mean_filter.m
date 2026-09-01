function output = knn_mean_filter(image, windowSize, k, includeCenter)
%KNN_MEAN_FILTER Average pixels closest in intensity to the center pixel.
validateattributes(image, {'numeric'}, {'2d', 'real', 'finite', 'nonempty'});
validateattributes(windowSize, {'numeric'}, {'scalar', 'integer', 'positive'});
if mod(windowSize, 2) == 0
    error("DIPToolkit:EvenWindow", "KNN window size must be odd.");
end
validateattributes(k, {'numeric'}, {'scalar', 'integer', 'positive'});
if nargin < 4
    includeCenter = true;
end
available = windowSize^2 - double(~includeCenter);
if k > available
    error("DIPToolkit:KNNK", "k cannot exceed the number of candidate pixels.");
end
[rows, columns] = size(image);
radius = floor(windowSize / 2);
output = zeros(rows, columns);
for row = 1:rows
    rowIndices = reflect_index(row + (-radius:radius), rows);
    for column = 1:columns
        columnIndices = reflect_index(column + (-radius:radius), columns);
        values = image(rowIndices, columnIndices);
        values = values(:);
        if ~includeCenter
            values((numel(values) + 1) / 2) = [];
        end
        [~, order] = sort(abs(values - image(row, column)), "ascend");
        output(row, column) = mean(values(order(1:k)));
    end
end
end
