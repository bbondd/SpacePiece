function coordinate = matrixToCoordinate(matrix)
matrix = rref(matrix);
matrixRank = rank(matrix);

%if rank(matrix) ~= coordinateSize || size(matrix, 2) ~= coordinateSize + 1
%    e = MException('wrong matrix');
%    throw(e)
%end

if size(matrix, 2) ~= rank(matrix) + 1 || matrix(matrixRank,matrixRank) == 0
    e = MException('wrong matrix', matrix);
    throw(e);
end

coordinate = matrix;
coordinate(:,[1 : 1 : matrixRank]) = [];
coordinate([matrixRank + 1 : 1 :size(matrix, 1)], :) = [];
coordinate = -coordinate;
end