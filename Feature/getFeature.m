% main function of extracts features
function feature = getfeature(image, par)
	imageHSV = image.HSV;
	imageYUV = image.YUV;
	
	count = 1;
	
	for height = 1:(par.height_stride):(par.imageheight+1-par.patchheight)
		for width = 1:(par.width_stride):(par.imagewidth+1-par.patchwidth)
			tempHSV = imageHSV(height:(height+par.patchheight-1), width:(width+par.patchwidth-1),:);	
			tempYUV = imageYUV(height:(height+par.patchheight-1), width:(width+par.patchwidth-1),:);
			
			[patch.HSV,patch.YUV] = get_patch_feature(tempHSV, tempYUV);
			patch.height = height;
			patch.width = width;
			feature{count} = patch;
			count = count + 1;
		end
	end
end

