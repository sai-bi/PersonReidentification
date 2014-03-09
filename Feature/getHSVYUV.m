% This program is used to get HSV-YUV feature.

% Some parameters:

par.patchheight = 4; % height of a patch
par.patchwidth = 8; % width of a patch

par.width_stride = 4; % stride along width
par.height_stride = 4; % stride along height

par.imageheight = 128;
par.imagewidth = 48;
% read images from cam_a & cam_b

h = waitbar(0,'Read images from cam a...');
folderA = dir('VIPeR/cam_a');
imageA = {};
for i = 3:size(folderA,1)
	waitbar((i-2)/632,h);
	imageName = strcat('VIPeR/cam_a/',folderA(i).name);
	imageRGB = imread(imageName);

	% convert RGB to HSV & YUV
	[imageA{i-2}.HSV, imageA{i-2}.YUV] = imageConvert(imageRGB);
end
close(h);

h = waitbar(0,'Read images from cam b...');
folderB = dir('VIPeR/cam_b');
imageB = {};
for i = 3:size(folderB,1)
	waitbar((i-2)/632,h);
	imageName = strcat('VIPeR/cam_b/',folderB(i).name);
	imageRGB = imread(imageName);

	% convert RGB to HSV & YUV
	[imageB{i-2}.HSV, imageB{i-2}.YUV] = imageConvert(imageRGB);
end
close(h);
save('oriImage.mat','imageA','imageB');

% Extract features 
h = waitbar(0, 'Extract features for cam a...');
HSVYUVFeatureA = {};
for i = 1:size(imageA,2)
	waitbar(i/632,h);
	HSVYUVFeatureA{i} = extractFeature(imageA{i}, par);
end
close(h);
h = waitbar(0,'Extract features from cam b...');
HSVYUVFeatureB = {};
for i = 1:size(imageB,2)
	waitbar(i/632,h);
	HSVYUVFeatureB{i} = extractFeature(imageB{i},par);
end

save('HSVYUVFeature.mat','HSVYUVFeatureA','HSVYUVFeatureB');
close(h);




