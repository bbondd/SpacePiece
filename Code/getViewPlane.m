function planeMatrix = getViewPlane(viewVector, xyLine)
if xyLine(3) == 0;%xyLine�� ������ ������ �����϶�
    xyLine(3) = 1;
    lawPoint = getViewPoint(viewVector, [xyLine; xyLine(2) -xyLine(1) 0]);
    lawVector = matrixToCoordinate(lawPoint);
    planeMatrix = rref([transpose(lawVector), 0]);  
else
    lawPoint = getViewPoint(viewVector, [xyLine; xyLine(2) -xyLine(1) 0]);
    lawVector = matrixToCoordinate(lawPoint);
    planeMatrix = rref([transpose(lawVector), -sum(lawVector.^2)]);
end
end