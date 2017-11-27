function scatterXYZpoints(xyzPoints)
x = xyzPoints(:,1); y = xyzPoints(:,2); z = xyzPoints(:,3);
scatter3(x,y,z,2);
end