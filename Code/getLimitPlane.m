function limitPlane = getLimitPlane(viewVector, xyPointA, xyPointB)

coordinateA = matrixToCoordinate(xyPointA);
coordinateB = matrixToCoordinate(xyPointB);

a = coordinateA(1); b = coordinateA(2); c = coordinateB(1); d = coordinateB(2);

limitPlane.viewVector = viewVector;
limitPlane.plane = getViewPlane(viewVector, [(b-d) (c-a) (a * d - b * c)]);
limitPlane.limitLineA = getViewLine(viewVector, xyPointA);
limitPlane.limitLineB = getViewLine(viewVector, xyPointB);

end