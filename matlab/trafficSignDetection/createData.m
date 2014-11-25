C = textscan(fopen([train_dir,'/gt_ws_seperated.txt']),'%s %d %d %d %d %d');

ii = [1 1 1 1 1];

for i = 1:length(C{1})
    if ismember(C{6}(i),[(1:11),(16:18),(33:43)])
        data.circle(ii(1)).imageFilename = [train_dir,'/',C{1}{i}];
        data.circle(ii(1)).objectBoundingBoxes = [C{2}(i),C{3}(i),C{4}(i)-C{2}(i),C{5}(i)-C{3}(i)];
        ii(1) = ii(1) + 1;
    end
    if ismember(C{6}(i),[12,(19:32)])
        data.triangle(ii(2)).imageFilename = [train_dir,'/',C{1}{i}];
        data.triangle(ii(2)).objectBoundingBoxes = [C{2}(i),C{3}(i),C{4}(i)-C{2}(i),C{5}(i)-C{3}(i)];
        ii(2) = ii(2) + 1;
    end
    if ismember(C{6}(i),[13])
        data.rhombus(ii(3)).imageFilename = [train_dir,'/',C{1}{i}];
        data.rhombus(ii(3)).objectBoundingBoxes = [C{2}(i),C{3}(i),C{4}(i)-C{2}(i),C{5}(i)-C{3}(i)];
        ii(3) = ii(3) + 1;
    end
    if ismember(C{6}(i),[14])
        data.triangle180(ii(4)).imageFilename = [train_dir,'/',C{1}{i}];
        data.triangle180(ii(4)).objectBoundingBoxes = [C{2}(i),C{3}(i),C{4}(i)-C{2}(i),C{5}(i)-C{3}(i)];
        ii(4) = ii(4) + 1;
    end
    if ismember(C{6}(i),[15])
        data.octagon(ii(5)).imageFilename = [train_dir,'/',C{1}{i}];
        data.octagon(ii(5)).objectBoundingBoxes = [C{2}(i),C{3}(i),C{4}(i)-C{2}(i),C{5}(i)-C{3}(i)];
        ii(5) = ii(5) + 1;
    end
    data.size = ii -1;
end

trainCascadeObjectDetector('circleSignDetector.xml', data.circle, negativeFolder);
trainCascadeObjectDetector('triangleSignDetector.xml', data.triangle, negativeFolder);
trainCascadeObjectDetector('rhombusSignDetector.xml', data.rhombus, negativeFolder);
trainCascadeObjectDetector('triangle180SignDetector.xml', data.triangle180, negativeFolder);
trainCascadeObjectDetector('octagonSignDetector.xml', data.octagon, negativeFolder);

data.circleSignDetector = vision.CascadeObjectDetector('circleSignDetector.xml');
data.triangleSignDetector = vision.CascadeObjectDetector('triangleSignDetector.xml');
data.rhombusSignDetector = vision.CascadeObjectDetector('rhombusSignDetector.xml');
data.triangle180SignDetector = vision.CascadeObjectDetector('triangle180SignDetector.xml');
data.octagonSignDetector = vision.CascadeObjectDetector('octagonSignDetector.xml');