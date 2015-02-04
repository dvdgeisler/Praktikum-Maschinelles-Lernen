detector = vision.CascadeObjectDetector('SignDetector.xml');
detector.MaxSize=[128 128];
for i=1:10:1000
    bbox = step(detector, mov(i).cdata );
    close all;detectedImg = insertObjectAnnotation(mov(i).cdata, 'rectangle', bbox, 'circular sign');
    figure; imshow(detectedImg);
    pause(1);
end