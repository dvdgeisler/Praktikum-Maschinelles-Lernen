clc
clear all;
close all;
trai_dir = '..\..\Data\pix\FullIJCNN2013\';
for i=0:899
%for i=0:0
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
    %pf = strcat(trai_dir,nus,'.png');
    imt=imread(pf,'ppm');
    %imt=imread(pf,'png');
    gs=rgb2gray(imt);
    gs = imadjust(gs);
    h = fspecial('gaussian',[50 50],2);
    gau = imfilter(gs,h,'same');
    level = (sum(sum(gau))/prod(size(gau)))/255;%graythresh(gau);
    BW = im2bw(gau,level);
    CA = edge(BW,'canny');
    figure
    imshow(imt);
    pause(0.5);
    imshow(gs);
    pause(0.5);
    imshow(gau);
    pause(0.5);
    imshow(BW);
    pause(0.5);
    imshow(CA);
    pause(3);
    [x,y]=find(CA==1);
    wo = fit_ellipse(x,y);
    %hold on;
    %plot(wo.X0,wo.Y0,'rx')
end