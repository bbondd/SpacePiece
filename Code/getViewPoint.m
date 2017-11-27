function pointMatrix = getViewPoint(viewVector, xyPoint)
coordinate = matrixToCoordinate(xyPoint);

a = viewVector(1); b = viewVector(2); c = viewVector(3);
p = coordinate(1); q = coordinate(2);

p_vector = resizeVector([-b; a; 0], p);
q_vector = resizeVector([-a*c; -b*c; a^2+b^2], q);

pointMatrix = coordinateToMatrix(p_vector + q_vector);
end