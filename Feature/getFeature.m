function [HSV,YUV] = getFeature(imageHSV,imageYUV)
	hChanel = vec(imageHSV(:,:,1));
	sChanel = vec(imageHSV(:,:,2));
	vChanel = vec(imageHSV(:,:,3));

	hHist = eightBinHist(hChanel,0,1);
	sHist = eightBinHist(sChanel,0,1);
	vHist = eightBinHist(vChanel,0,1);
	
	momentH = colorMoments(hChanel);
	momentS = colorMoments(sChanel);
	momentV = colorMoments(vChanel);

	HSV = [hHist;sHist;vHist;momentH;momentS;momentV];


	hChanel = vec(imageYUV(:,:,1));
	sChanel = vec(imageYUV(:,:,2));
	vChanel = vec(imageYUV(:,:,3));

	hHist = eightBinHist(hChanel,16,235);
	sHist = eightBinHist(sChanel,16,240);
	vHist = eightBinHist(vChanel,16,240);
	
	momentH = colorMoments(double(hChanel));
	momentS = colorMoments(double(sChanel));
	momentV = colorMoments(double(vChanel));

	YUV = [hHist;sHist;vHist;momentH;momentS;momentV];
end

