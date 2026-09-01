function index = reflect_index(index, lengthValue)
%REFLECT_INDEX Mirror any integer index into [1,lengthValue].
if lengthValue < 1
    error("DIPToolkit:EmptyDimension", "Dimension length must be positive.");
end
if lengthValue == 1
    index(:) = 1;
    return;
end
period = 2 * lengthValue - 2;
index = mod(index - 1, period) + 1;
pastEnd = index > lengthValue;
index(pastEnd) = period - index(pastEnd) + 2;
end
