function rotateMatrix = getRotateMatrix(rotateAngle)
    rotateMatrix = [cos(rotateAngle) -sin(rotateAngle); sin(rotateAngle) cos(rotateAngle)];
end