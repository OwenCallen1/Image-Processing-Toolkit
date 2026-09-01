function image = read_grayscale(path)
%READ_GRAYSCALE Read an image and normalize it to double precision [0,1].
if ~isfile(path)
    error("DIPToolkit:InputNotFound", "Image not found: %s", path);
end
raw = imread(path);
sourceClass = class(raw);
if ndims(raw) == 3
    if size(raw, 3) < 3
        raw = raw(:, :, 1);
    else
        raw = 0.298936 * double(raw(:, :, 1)) + ...
            0.587043 * double(raw(:, :, 2)) + ...
            0.114021 * double(raw(:, :, 3));
        if isinteger(cast(0, sourceClass))
            raw = raw / double(intmax(sourceClass));
        end
    end
end
if isinteger(raw)
    image = double(raw) / double(intmax(class(raw)));
else
    image = double(raw);
    low = min(image(:));
    high = max(image(:));
    if low < 0 || high > 1
        if high > low
            image = (image - low) / (high - low);
        else
            image = zeros(size(image));
        end
    end
end
image = min(max(image, 0), 1);
end
