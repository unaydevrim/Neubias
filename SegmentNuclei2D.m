
function SegmentNuclei2D(imagename)

if (nargin<1)
    fprintf('Usage:\n\tCD to the directory of the images\n\tInput the imagename as an argument.\n');
    return;
end

% Read image
I = imread(imagename);

% Apply OTSU thresholding over the whole image
level = graythresh(I);
levelconverted = level * 255;

% Apply Extended Minimum Transform with the threshold value
BW = imextendedmin(I,levelconverted);

% Complement the result
BW = squeeze(BW(:,:,1));
BW = imcomplement(BW);

% Apply morphological cleaning
BW = bwareaopen(BW,200); % Remove binary objects with area less than 50
se = strel('disk',1);
BW = imclose(BW,se);
BW = imfill(BW,'holes');

% Save segmentation mask
imwrite(BW,['SegMask_' imagename],'tif');

% Display segmentation on the original
BWoutline = bwperim(BW);
SegOut = I;
SegOut(BWoutline) = 255;
imshow(SegOut); 
title(imagename);

fprintf([imagename ' segmented!\n']);