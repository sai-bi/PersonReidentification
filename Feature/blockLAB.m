%Block LAB returns the LAB histogram of an image in block mode.
%  J = blockLAB(I, CELLSIZE,STRIDE, bins, MODE) returns the blocks of local binary pattern 
%  histogram of an intensity image I. T
%   Possible values for MODE are
%       'h' or 'hist'  to get a histogram of HSV image
%       'nh'           to get a normalized histogram
%
%  J = blockLAB(I, CELLSIZE, STRIDE, bins) returns the original (basic) block LAB histogram of image I
%
%
%  Examples
%  --------
%       I=imread('peppers.png');
%       H1=blockLAB(I,[8,16],[8,8], [24, 24, 24], 'h'); %block LAB histogram in (8,1) neighborhood
%       subplot(2,1,1),stem(H1);
%
%       H2=blockHSV(I,[8,16],[8,8], [24, 24, 24]);
%       subplot(2,1,2),stem(H2);
%


function finalResult = blockLAB(varargin) % image,radius,neighbors,mapping,mode, blocksize, stride)
% Authors: Guanbin Li


% Check number of input arguments.
error(nargchk(1,5,nargin));

image=varargin{1};
C = makecform('srgb2lab'); 
lab = applycform(image,C);
 ll   = lab(:,:,1);
ll   = histeq(ll);
 aa   = lab(:,:,2);
 aa   = histeq(aa);
 bb   = lab(:,:,3);
 bb   = histeq(bb);
 lab     =   cat(3,ll,aa,bb); % eq. HSV
 
%  ll = lab(:,:,1) - lab(:,:,2);
%  aa = lab(:,:,1) + lab(:,:,2) - 2*lab(:,:,3);
%  bb = lab(:,:,1) + lab(:,:,2) + lab(:,:,3);
 
d_image= lab;

if nargin>=4
    mode='h';
    cellsize = varargin{2};
    stride = varargin{3};
    bins = varargin{4};
end

    
if(nargin >= 5)
     mode=varargin{5};
else
     mode='h';
end
    

% Determine the dimensions of the input image.
S = size(image);
ysize = S(1);
xsize = S(2);
ii = 1;
jj = 1;

blockYSize = cellsize(2);
blockXSize = cellsize(1);
for dim = 1:3
    img_tmp = d_image(:,:,dim);
    img_tmp = floor(img_tmp/255*(bins(dim)-1));
    ii = 1;
    for bh = 1:stride(2):ysize-blockYSize+1
     jj = 1;
     for bw = 1:stride(1):xsize-blockXSize+1
        blockImg = d_image(bh:bh+blockYSize-1,bw:bw+blockXSize-1,dim);
 blockHist = img_tmp(bh:bh+blockYSize-1,bw:bw+blockXSize-1);

if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    result=hist(blockImg(:),bins(dim));
    if (strcmp(mode,'nh'))
        result=result/sum(result);
    end
elseif (strcmp(mode,'mean'))
       result = ceil(mean(blockHist(:)));
      %AA = double(blockHist(:));
      %result = ceil(median(AA));
    
else
    %Otherwise return a matrix of unsigned integers
    if ((bins-1)<=intmax('uint8'))
        result=uint8(result);
    elseif ((bins-1)<=intmax('uint16'))
        result=uint16(result);
    else
        result=uint32(result);
    end
end

finalResult{ii,jj,dim} = result;
jj = jj + 1;
    
    end
    ii = ii + 1;
end

end