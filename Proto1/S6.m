clear all;
clc;
%xyloObj = vision.VideoFileReader('..\..\Data\vid\Sindelsdorf.mp4');
%xyloObj = vision.VideoFileReader('..\..\Data\vid\lind.mp4');
xyloObj = vision.VideoFileReader('..\..\Data\vid\garm.mp4');
%recorder = VideoWriter('..\..\Data\vid\pres1.avi');
videoInfo    = info(xyloObj);

%recorder.FrameRate = videoInfo.VideoFrameRate/2;
%open(recorder);
videoPlayer  = vision.VideoPlayer('Position',[300 300 videoInfo.VideoSize+30]);

tags = {'circular','triangular','rhombus','triangle180','octagon'};
detk = {'SignDetector1.xml','SignDetector2.xml','SignDetector3.xml','SignDetector4.xml','SignDetector5.xml'};
for i=1:length(detk)
    detector{i} = vision.CascadeObjectDetector(detk{i});
    detector{i}.MaxSize=[64 64];
end

vbox{length(detector)} = [];
% i=1;
while ~isDone(xyloObj)
    tmp = step(xyloObj);
    %%if i>3260 && i<=3400
    cp = tmp;
    for l=1:length(detector)
        bbox = step(detector{l}, tmp );
        tbox = bbox;
        bbox = interset(vbox{l},bbox);
        cp = insertObjectAnnotation(cp, 'rectangle', bbox, strcat(tags{l},' sign'));
        vbox{l} = tbox;
    end
    step(videoPlayer, cp);
    
%     writeVideo(recorder, cp);
    %end
%     if i==3400
%         break;
%     end
%     i = i+1;
end
%close(recorder);
release(videoFileReader);
release(videoPlayer);