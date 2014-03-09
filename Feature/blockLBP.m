%Block LBP returns the LBP histogram of an image in block mode.
%  J = BlockLBP(I,R,N,MAPPING,MODE,CELLSIZE, STRIDE) returns the blocks of local binary pattern 
%  histogram of an intensity image I. The LBP codes are computed using N 
%  sampling points on a circle of radius R and using mapping table defined by MAPPING. 
%  See the getmapping function for different mappings and use 0 for
%  no mapping. Possible values for MODE are
%       'h' or 'hist'  to get a histogram of LBP codes
%       'nh'           to get a normalized histogram
%
%  J = LBP(I, CELLSIZE, STRIDE) returns the original (basic) block LBP histogram of image I
%
%
%  Examples
%  --------
%       I=imread('rice.png');
%       mapping=getmapping(8,'u2'); 
%       H1=blockLBP(I,1,8,mapping,'h',[8,16],[8,8]); %LBP histogram in (8,1) neighborhood
%                                  %using uniform patterns
%       subplot(2,1,1),stem(H1);
%
%       H2=LBP(I,[8,16],[8,8]);
%       subplot(2,1,2),stem(H2);
%


function finalResult = blockLBP(varargin) % image,radius,neighbors,mapping,mode, blocksize, stride)
% Authors: Guanbin Li

% Version 0.3.1: Changed MAPPING input to be a struct containing the mapping
% table and the number of bins to make the function run faster with high number
% of sampling points. Lauge Sorensen is acknowledged for spotting this problem.


% Check number of input arguments.
error(nargchk(1,7,nargin));

image=varargin{1};
%grayimg = image;
grayimg = histeq(rgb2gray(image));

d_image = grayimg;

if nargin==3
    spoints=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
    neighbors=8;
    radius = 1;
    mapping=0;
    mode='h';
    cellsize = varargin{2};
    stride = varargin{3};


else



    
    if(nargin >= 4)
        radius = varargin{2};
        neighbors = varargin{3};
        mapping=varargin{4};
        if(isstruct(mapping) && mapping.samples ~= neighbors)
            error('Incompatible mapping');
        end
    else
        mapping=0;
    end
    
    if(nargin >= 5)
        mode=varargin{5};
    else
        mode='h';
    end
    
    if(nargin >= 6)
        cellsize = varargin{6};
    else
        cellsize = [8,16];
    end
    
    if(nargin >= 7)
        stride = varargin{7};
    else
        stride = [8,8];
    end
end


% Determine the dimensions of the input image.
[ysize xsize] = size(d_image);

ii = 1;
jj = 1;

blockYSize = cellsize(2);
blockXSize = cellsize(1);

for bh = 1:stride(2):ysize-blockYSize+1
    jj = 1;
    for bw = 1:stride(1):xsize-blockXSize+1
        blockImg = d_image(bh:bh+blockYSize-1,bw:bw+blockXSize-1);
        miny=min(spoints(:,1));
        maxy=max(spoints(:,1));
        minx=min(spoints(:,2));
        maxx=max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
        bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
        bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
        origy=1-floor(min(miny,0));
        origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
        if(blockXSize < bsizex || blockYSize < bsizey)
            error('Too small input image block. Should be at least (2*radius+1) x (2*radius+1)');
        end

% Calculate dx and dy;
        dx = blockXSize - bsizex;
        dy = blockYSize - bsizey;

% Fill the center pixel matrix C.
        C = blockImg(origy:origy+dy,origx:origx+dx);
        d_C = double(C);

        %bins = 2^neighbors;
        bins = 32;
% Initialize the result matrix with zeros.
        result=zeros(dy+1,dx+1);

%Compute the LBP code image

for i = 1:neighbors
  y = spoints(i,1)+origy;
  x = spoints(i,2)+origx;
  % Calculate floors, ceils and rounds for the x and y.
  fy = floor(y); cy = ceil(y); ry = round(y);
  fx = floor(x); cx = ceil(x); rx = round(x);
  % Check if interpolation is needed.
  if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
    % Interpolation is not needed, use original datatypes
    N = blockImg(ry:ry+dy,rx:rx+dx);
    D = N >= C; 
  else
    % Interpolation needed, use double type images 
    ty = y - fy;
    tx = x - fx;

    % Calculate the interpolation weights.
    w1 = (1 - tx) * (1 - ty);
    w2 =      tx  * (1 - ty);
    w3 = (1 - tx) *      ty ;
    w4 =      tx  *      ty ;
    % Compute interpolated pixel values
    N = w1*blockImg(fy:fy+dy,fx:fx+dx) + w2*blockImg(fy:fy+dy,cx:cx+dx) + ...
        w3*blockImg(cy:cy+dy,fx:fx+dx) + w4*blockImg(cy:cy+dy,cx:cx+dx);
    D = N >= d_C; 
  end  
  % Update the result matrix.
  v = 2^(i-1);
  result = result + v*D;
end

%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(result,1)
        for j = 1:size(result,2)
            result(i,j) = mapping.table(result(i,j)+1);
        end
    end
end

if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    result=hist(result(:),0:(bins-1));

    if (strcmp(mode,'nh'))
        result=result/sum(result);
    end
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

finalResult{ii,jj} = result;
jj = jj + 1;
    
    end
    ii = ii + 1;
end

end