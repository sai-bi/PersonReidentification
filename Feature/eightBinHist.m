%this function is used to calculate the histograms the sample.
%the histogram is a standard 8-bin histogram.
function eightBin = eightBinHist(value,minValue,maxValue)
	%divide 0-1 into 8 parts, that is 0 - 0.125, 0,125--0.25,...
	%use histc() to count the frequency
	bins = linspace(minValue,maxValue,9);   
	eightBin = histc(value,bins);   
	eightBin = eightBin(1:8); 
end


