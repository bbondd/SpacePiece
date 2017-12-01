function main()

vector1 = input('First Vector : '); 
path1 = input('First Image Path : ');
rotateAngle1 = input('First Image Rotate Angle : '); 

vector2 = input('Second Vector : '); 
path2 = input('Second Image Path : ');
rotateAngle2 = input('Second Image Rotate Angle : ');

vector3 = input('Third Vector : ');
path3 = input('Third Image Path : ');
rotateAngle3 = input('Third Image Rotate Angle : ');

vectors = [vector1 vector2 vector3]; 
paths = char(path1, path2, path3);

rotateAngles = [rotateAngle1 rotateAngle2 rotateAngle3];

xyzPoints = getXYZpointsFromThreeImages(vectors, paths, rotateAngles);

scatterXYZpoints(xyzPoints);
end

function matrix = coordinateToMatrix(coordinate)
size(coordinate,1);
matrix = [eye(size(coordinate,1)), -coordinate];
end

function resizedVector = resizeVector(vector, size)
resizedVector = vector*size/sqrt(vector(1)^2 + vector(2)^2 + vector(3)^2);
end

function coordinate = matrixToCoordinate(matrix)
matrix = rref(matrix);
matrixRank = rank(matrix);

if size(matrix, 2) ~= rank(matrix) + 1 || matrix(matrixRank,matrixRank) == 0
    e = MException('wrong matrix', matrix);
    throw(e);
end

coordinate = matrix;
coordinate(:,[1 : 1 : matrixRank]) = [];
coordinate([matrixRank + 1 : 1 :size(matrix, 1)], :) = [];
coordinate = -coordinate;
end

function rotateMatrix = getRotateMatrix(rotateAngle)
    rotateMatrix = [cos(rotateAngle) -sin(rotateAngle); sin(rotateAngle) cos(rotateAngle)];
end

function pointMatrix = getViewPoint(viewVector, xyPoint)
coordinate = matrixToCoordinate(xyPoint);

a = viewVector(1); b = viewVector(2); c = viewVector(3);
p = coordinate(1); q = coordinate(2);

p_vector = resizeVector([-b; a; 0], p);
q_vector = resizeVector([-a*c; -b*c; a^2+b^2], q);

pointMatrix = coordinateToMatrix(p_vector + q_vector);
end

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

function limitPlane = getLimitPlane(viewVector, xyPointA, xyPointB)

coordinateA = matrixToCoordinate(xyPointA);
coordinateB = matrixToCoordinate(xyPointB);

a = coordinateA(1); b = coordinateA(2); c = coordinateB(1); d = coordinateB(2);

limitPlane.viewVector = viewVector;
limitPlane.plane = getViewPlane(viewVector, [(b-d) (c-a) (a * d - b * c)]);
limitPlane.limitLineA = getViewLine(viewVector, xyPointA);
limitPlane.limitLineB = getViewLine(viewVector, xyPointB);

end

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

end

function limitPlanes = getLimitPlanesFromImage(viewVector, image, rotateAngle)
imageRowSize = size(image, 1);
imageColSize = size(image, 2);
imageHalfRowSize = floor(imageRowSize/2);
imageHalfColSize = floor(imageColSize/2);

xyPoints = zeros(imageRowSize, 2);

for i = 1:1:imageRowSize
    st = 0; ed = 0;
    for j = 1:1:imageColSize - 1
        if (image(i, j, 1) == 255) && (image(i, j+1, 1) ~= 255)
            st = j + 1;
        elseif (image(i,j,1) ~= 255) && (image(i, j+1, 1) == 255)
            ed = j;
        end
    end
    xyPoints(i,1) = st;
    xyPoints(i,2) = ed;
end

limitPlanes = [];

for i = 1:1:size(xyPoints, 1)
    if xyPoints(i, 1) == 0 && xyPoints(i, 2) == 0
        continue;
    end
    
    y = imageHalfRowSize - i;
    x1 = xyPoints(i, 1) - imageHalfColSize;
    x2 = xyPoints(i, 2) - imageHalfColSize; 
    
    rotateMatrix = getRotateMatrix(rotateAngle);
    
    tempLimitPlane = getLimitPlane(viewVector, coordinateToMatrix(rotateMatrix*[x1; y]), coordinateToMatrix(rotateMatrix*[x2; y]));
    limitPlanes = [limitPlanes; tempLimitPlane];
end

end

function xyzPoints = getXYZpointsFromThreeImages(viewVectors, filePaths, rotateAngles)
imageA = imread(filePaths(1,:)); imageB = imread(filePaths(2,:)); imageC = imread(filePaths(3,:));

limitPlanesA = getLimitPlanesFromImage(viewVectors(:,1), imageA, rotateAngles(1));
limitPlanesB = getLimitPlanesFromImage(viewVectors(:,2), imageB, rotateAngles(2));
limitPlanesC = getLimitPlanesFromImage(viewVectors(:,3), imageC, rotateAngles(3));

A(size(limitPlanesA, 1)).B(size(limitPlanesB, 1)).C(size(limitPlanesC, 1)).xyzPoint = [];

parfor i = 1:1:size(limitPlanesA, 1)
    for j = 1:1:size(limitPlanesB, 1)
        for k = 1:1:size(limitPlanesC, 1)
            tempXYZpoint = [limitPlanesA(i).plane; limitPlanesB(j).plane; limitPlanesC(k).plane];
            boolA = isXYZpointInLimitPlane(limitPlanesA(i), tempXYZpoint);
            boolB = isXYZpointInLimitPlane(limitPlanesB(j), tempXYZpoint);
            boolC = isXYZpointInLimitPlane(limitPlanesC(k), tempXYZpoint);
            
            if boolA && boolB && boolC
                A(i).B(j).C(k).xyzPoint = transpose(matrixToCoordinate(tempXYZpoint));
            else
                A(i).B(j).C(k).xyzPoint = [];
            end
        end
    end
end


xyzPoints = zeros(size(limitPlanesA, 1) * size(limitPlanesB, 1) * size(limitPlanesC, 1), 3);

count = 1;
for i = 1:1:size(limitPlanesA, 1)
    for j = 1:1:size(limitPlanesB, 1)
        for k = 1:1:size(limitPlanesC, 1)
            if size(A(i).B(j).C(k).xyzPoint, 2) ~= 0
                xyzPoints(count,:) = A(i).B(j).C(k).xyzPoint;
                count = count + 1;
            end
        end
    end
end




xyzPoints([count:1:size(xyzPoints, 1)], :) = [];
end

function scatterXYZpoints(xyzPoints)
x = xyzPoints(:,1); y = xyzPoints(:,2); z = xyzPoints(:,3);
scatter3(x,y,z,2);
end