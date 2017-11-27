function matrix = coordinateToMatrix(coordinate)
size(coordinate,1);
matrix = [eye(size(coordinate,1)), -coordinate];