function [featureHSV,featureYUV] = get_patch_feature(sample1,sample2)
	%the feature is composed of two parts, the first part is a 8-bin
	%histogram of the three channels(HSV or YUV). The second part is the 
	%color moment of the three channels.

	%get historgram for H,S,V or Y,U,V

	%value for Hue in HSV 
	hPart = eightBinHist(vec(sample1(:,:,1)), 0, 1); 
	%value for Saturation in HSV or U in YUV
	sPart = eightBinHist(vec(sample1(:,:,2)),0,1);
	%value for V in HSV and YUV
    vPart = eightBinHist(vec(sample1(:,:,3)),0,1);

	%get three color moments for H,S,V or Y,U,V
	momentH = colorMoments(vec(sample1(:,:,1)));
	momentS = colorMoments(vec(sample1(:,:,2)));
	momentV = colorMoments(vec(sample1(:,:,3)));
     
	featureHSV = [hPart;sPart;vPart;momentH;momentS;momentV];

    
    %calculate feature for YUV
	yPart = eightBinHist(vec(sample2(:,:,1)), 16, 235); 
	%value for Saturation in HSV or U in YUV
	uPart = eightBinHist(vec(sample2(:,:,2)),16,240);
	%value for V in HSV and YUV
    vPart = eightBinHist(vec(sample2(:,:,3)),16,240);

	%get three color moments for H,S,V or Y,U,V
	momentY = colorMoments(double(vec(sample2(:,:,1))));
	momentU = colorMoments(double(vec(sample2(:,:,2))));
	momentV = colorMoments(double(vec(sample2(:,:,3))));
     
	featureYUV = [yPart;uPart;vPart;momentY;momentU;momentV];
    
    
end
