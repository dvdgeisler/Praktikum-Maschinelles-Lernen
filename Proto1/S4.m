% trainCascadeObjectDetector('SignDetector5.xml',data,neg,'FalseAlarmRate',0.2,'NumCascadeStages',6);
detector = vision.CascadeObjectDetector('SignDetector1.xml');
trai_dir = '..\..\Data\pix\FullIJCNN2013\';
detector.MaxSize=[128 128];
for i=0:899
    close all;
    if i<10
        top = 4;
    elseif i<100
        top = 3;
    else
        top = 2;
    end
    nus = num2str(i);
    for j=1:top
        nus = strcat(num2str(0),nus);
    end
    pf = strcat(trai_dir,nus,'.ppm');
    img = imread(pf);
    bbox = step(detector, img);
    detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'circular sign');
    figure; imshow(detectedImg);
    pause(1);
end