clc; clear all; close all;

StartingFrame = 1;
EndingFrame = 448;

Xcentroid = [];
Ycentroid = [];

for k = StartingFrame : EndingFrame-1
    clc;
    fprintf('Reading image %1.0f\n',k);
    pos1 = imread(['ant/img',sprintf('%2.3d',k),'.jpg']);
    pos2 = imread(['ant/img',sprintf('%2.3d',k+1),'.jpg']);
    
    rgb1 = rgb2hsv(pos1);
    rgb2 = rgb2hsv(pos2);
    grey1 = rgb1(:,:,3);
    grey2 = rgb2(:,:,3);
    
    diff1=abs(grey1-grey2);
    
    Ithresh = diff1 > 0.05;
    SE = strel('disk',3,0);
    Iopen = imopen(Ithresh,SE);
    Iclose = imclose(Iopen,SE);

    [labels,number] = bwlabel(Iclose,8);
    
    if number > 0
        Istats = regionprops(labels, 'basic', 'Centriod');
        [maxVal, maxIndex] = max([Istats.Area]);
        
        Xcentroid = [Xcentroid Istats(maxIndex).Centroid(1)];
        Ycentroid = [Ycentroid Istats(maxIndex).Centroid(2)];
    end
    
end
clc;
fprintf('Outputting path\n');
imshow(pos2);
hold on;
plot(Xcentroid, Ycentroid);