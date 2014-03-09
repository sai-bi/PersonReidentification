%featureExtraction returns the HSV, LAB, LBP histogram feature of an image in block mode.
%  J = featureExtraction(I, CELLSIZE, STRIDE, bins, MODER, R, N, MAPPING ) returns the blocks of features 
%  I: the image. 
%  CELLSIZE: the size of each block
%  STRIDE: the step between each block
%  bins: the number of bins to calculate the histogram
%  The LBP codes are computed using N sampling points on a circle of radius R and using mapping table defined by MAPPING. 
%  See the getmapping function for different mappings and use 0 for no mapping. Possible values for MODE are
%       'h' or 'hist'  to get a histogram of LBP codes
%       'nh'           to get a normalized histogram
%
%  J = LBP(I, CELLSIZE, STRIDE, bins) returns the basic feature of image I
%
%
%  Examples
%  --------
%       I=imread('rice.png');
%       mapping=getmapping(8,'u2'); 
%       H1=featureExtraction(I,[8,16],[8,8],[24,24,24],[8,16],[8,8],'h', 1, 8, mapping);
%       %feature extraction
%                                  %using uniform patterns
%       subplot(2,1,1),stem(H1);
%
%       H2=featureExtraction(I,[8,16],[8,8],[24,24,24],[8,16],[8,8]);
%       subplot(2,1,2),stem(H2);
%


function patch = labExtractFeature(varargin) % image,radius,neighbors,mapping,mode, blocksize, stride)
% Authors: Guanbin Li

% Version 0.3.1: Changed MAPPING input to be a struct containing the mapping
% table and the number of bins to make the function run faster with high number
% of sampling points. Lauge Sorensen is acknowledged for spotting this problem.


% Check number of input arguments.
error(nargchk(1,10,nargin));

image=varargin{1};
%grayimg = image;

if nargin == 6
    neighbors=8;
    r = 1;
    mapping=0;
    mode='h';
    cellsize = varargin{2};
    stride = varargin{3};
    bins = varargin{4};
    cellsize_lbp = varargin{5};
    stride_lbp = varargin{6};
end

if nargin == 10
    cellsize = varargin{2};
    stride = varargin{3};
    bins = varargin{4};
    cellsize_lbp = varargin{5};
    stride_lbp = varargin{6};
    mode = varargin{7};
    r = varargin{8};
    neighbors = varargin{9};
    mapping = varargin{10}; 
end

hsvHist = blockHSV(image, cellsize, stride, bins, mode);
%hsvHist2 = blockHSV(image, 2*cellsize, 2*stride, bins, mode);
% hsvHist3 = blockHSV(image, 3*cellsize, 3*stride, bins, mode);

labHist = blockLAB(image, cellsize, stride, bins, mode);
%labHist2 = blockLAB(image, 2*cellsize, 2*stride, bins, mode);
lbpHist = blockLBP(image, cellsize_lbp, stride_lbp);

fsize = size(hsvHist);
fsize_lbp = size(lbpHist);
finalResult=[];

patch = {};
count = 1;
for i=1:fsize(1)
    for j=1:fsize(2)
        temp = [];
        for k = 1:fsize(3)
            temp = [temp, hsvHist{i,j,k}(:)'];
        end
        for k = 1:fsize(3)
            temp = [temp, labHist{i,j,k}(:)'];
        end
        temp = [temp,lbpHist{i,j}(:)'];
        
        patch{count} = temp;
        count = count + 1;
    end
end
        

% for i=1:fsize(1)
%     for j=1:fsize(2)
%         for k = 1:fsize(3)
%             finalResult = [finalResult, labHist{i,j,k}(:)'];
%         end
%     end
% end
% 
% 
% 
% for i=1:fsize_lbp(1)
%     for j=1:fsize_lbp(2)
%         finalResult = [finalResult,lbpHist{i,j}(:)'];
%     end
% end

end
