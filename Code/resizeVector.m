function resizedVector = resizeVector(vector, size)
resizedVector = vector*size/sqrt(vector(1)^2 + vector(2)^2 + vector(3)^2);
end