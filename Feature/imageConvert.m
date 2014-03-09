% This function is used to convert RGB to HSV & YUV

function [imageHSV,imageYUV]=imageConvert(imageRGB)
	imageHSV = rgb2hsv(imageRGB);
        imageYUV = rgb2ycbcr(imageRGB);
end
