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