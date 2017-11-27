function xyzPoints = getXYZpointsFromThreeImages(viewVectors, filePaths, rotateAngles)
imageA = imread(filePaths(1,:)); imageB = imread(filePaths(2,:)); imageC = imread(filePaths(3,:));

limitPlanesA = getLimitPlanesFromImage(viewVectors(:,1), imageA, rotateAngles(1));
limitPlanesB = getLimitPlanesFromImage(viewVectors(:,2), imageB, rotateAngles(2));
limitPlanesC = getLimitPlanesFromImage(viewVectors(:,3), imageC, rotateAngles(3));

xyzPoints = zeros(size(limitPlanesA, 1) * size(limitPlanesB, 1) * size(limitPlanesC, 1), 3);
count = 1;
for i = 1:1:size(limitPlanesA, 1)
    for j = 1:1:size(limitPlanesB, 1)
        for k = 1:1:size(limitPlanesC, 1)
            tempXYZpoint = [limitPlanesA(i).plane; limitPlanesB(j).plane; limitPlanesC(k).plane];
            boolA = isXYZpointInLimitPlane(limitPlanesA(i), tempXYZpoint);
            boolB = isXYZpointInLimitPlane(limitPlanesB(j), tempXYZpoint);
            boolC = isXYZpointInLimitPlane(limitPlanesC(k), tempXYZpoint);
            
            if boolA && boolB && boolC
                xyzPoints(count, :) = transpose(matrixToCoordinate(tempXYZpoint));
                count = count + 1;
            end
        end
    end
end

xyzPoints([count:1:size(xyzPoints, 1)], :) = [];
end