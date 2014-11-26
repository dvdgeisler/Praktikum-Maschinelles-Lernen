xyloObj = VideoReader('..\..\Data\vid\lind.mp4');

vidWidth = xyloObj.Width;
vidHeight = xyloObj.Height;
nFrames = xyloObj.NumberOfFrames;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

for k = 1 : nFrames
    mov(k).cdata = read(xyloObj,k);
end

hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);

movie(hf,mov,1,xyloObj.FrameRate);