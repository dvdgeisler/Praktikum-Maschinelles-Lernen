clear all;
clc;
xyloObj = VideoReader('..\..\Data\vid\garm.mp4');

vidWidth = xyloObj.Width;
vidHeight = xyloObj.Height;
nFrames = xyloObj.NumberOfFrames;

di = 2000;
li = round(nFrames/di);
tags = {'circular','triangular','rhombus','triangle180','octagon'};
detk = {'SignDetector1.xml','SignDetector2.xml','SignDetector3.xml','SignDetector4.xml','SignDetector5.xml'};
for i=1:length(detk)
    detector{i} = vision.CascadeObjectDetector(detk{i});
    detector{i}.MaxSize=[64 64];
end
hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);
vbox{length(detector)} = [];
for i=5:li
    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
    for k = 1 : di
        tmp = read(xyloObj,(i-1)*di + k);
        cp = tmp;
        for l=1:length(detector)
             bbox = step(detector{l}, tmp );
             tbox = bbox;
             bbox = interset(vbox{l},bbox);
             cp = insertObjectAnnotation(cp, 'rectangle', bbox, strcat(tags{l},' sign'));
             vbox{l} = tbox;
        end
        mov(k).cdata = cp;
    end
    movie(hf,mov,1,xyloObj.FrameRate);
end
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
for i=(li*di+1):nFrames
    mov(i-li*di).cdata = read(xyloObj,i);
end
movie(hf,mov,1,xyloObj.FrameRate);