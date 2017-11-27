function resultBoolean = isXYZpointInLimitPlane(limitPlane, xyzPoint)

viewVector = limitPlane.viewVector;
limitLineA = limitPlane.limitLineA;
limitLineB = limitPlane.limitLineB;
xyzCoordinate = matrixToCoordinate(xyzPoint);

try 
    coordinate1 = matrixToCoordinate([limitLineA; 0 0 1 0]);%z == 0 
catch e
    try
        coordinate1 = matrixToCoordinate([limitLineA; 0 1 0 0]);%y == 0
    catch e
        coordinate1 = matrixToCoordinate([limitLineA; 1 0 0 0]);%x == 0
    end
end
    
try
    coordinate2 = matrixToCoordinate([limitLineB; 0 0 1 0]);%z == 0
catch e
    try
        coordinate2 = matrixToCoordinate([limitLineB; 0 1 0 0]);%y == 0
    catch e
        coordinate2 = matrixToCoordinate([limitLineB; 1 0 0 0]);%x == 0
    end
end

flag = dot(cross(viewVector, xyzCoordinate - coordinate1), cross(viewVector, xyzCoordinate - coordinate2));

if flag < 0
    resultBoolean = 1;
else
    resultBoolean = 0;
end

%if (limitPlane.plane*[matrixToCoordinate(xyzPoint);1]) ~= 0
%    resultBoolean = 0;
%end
end