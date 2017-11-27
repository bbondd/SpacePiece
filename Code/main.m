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