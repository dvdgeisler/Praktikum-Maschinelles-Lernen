function [ I , bbox_circle , bbox_triangle , bbox_rhombus , bbox_triangle180 , bbox_octagon ] = detect( data , train_dir, file )
    I = imread([train_dir,'/',file]);
    bbox_circle = step(data.circleSignDetector, I);
    bbox_triangle = step(data.triangleSignDetector, I);
    bbox_rhombus = step(data.rhombusSignDetector, I);
    bbox_triangle180 = step(data.triangle180SignDetector, I);
    bbox_octagon = step(data.octagonSignDetector, I);
    I = insertObjectAnnotation(I, 'rectangle', bbox_circle, 'circle');
    I = insertObjectAnnotation(I, 'rectangle', bbox_triangle, 'triangle');
    I = insertObjectAnnotation(I, 'rectangle', bbox_rhombus, 'rhombus');
    I = insertObjectAnnotation(I, 'rectangle', bbox_triangle180, 'triangle180');
    I = insertObjectAnnotation(I, 'rectangle', bbox_octagon, 'octagon');
end

