function lineMatrix = getViewLine(viewVector, xyPoint)
pointMatrix = getViewPoint(viewVector, xyPoint);
coordinate = matrixToCoordinate(pointMatrix);

a = viewVector(1); b = viewVector(2); c = viewVector(3);
a0 = coordinate(1); b0 = coordinate(2); c0 = coordinate(3);

lineMatrix = [ 0, c, -b, (b*c0 - b0*c);
                  c, 0, -a, (a*c0 - a0*c);
                  b, -a, 0, (a*b0 -a0*b)];
              
lineMatrix = rref(lineMatrix);
lineMatrix(3, :) = [];
end