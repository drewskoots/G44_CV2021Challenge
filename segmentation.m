function segm(originalImage, contentType)

original = originalImage;
captionFontSize = 14;
originalImage = rgb2gray(originalImage);
if contentType == 0
    % Force it to display RIGHT NOW
    drawnow;
    caption = sprintf('Original');
    title(caption, 'FontSize', captionFontSize);
    axis image; 


    [pixelCount, grayLevels] = imhist(originalImage);
    subplot(3, 3, 2);
    bar(pixelCount);
    title('Histogram of original image', 'FontSize', captionFontSize);
    xlim([0 grayLevels(end)]); % Scale x axis manually.
    grid on;

    % Threshold the image to get a binary image
    thresholdValue = 120;
    binaryImage = originalImage > thresholdValue; % Bright objects will be chosen if you use >.
    %get rid of any background pixels or "holes" inside the blobs.
    %%binaryImage = imfill(binaryImage, 'holes');
    
    % Maximize the figure window.
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

    % Show the threshold as a vertical red bar on the histogram.
    hold on;
    maxYValue = ylim;
    line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
    % Place a text label on the bar chart showing the threshold.
    annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
    % For text(), the x and y need to be of the data class "double" so let's cast both to double.
    text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
    text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
    text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);
    
else
    % into 3 separate 2D arrays, one for each color component.
    redBand = original(:, :, 1);
    greenBand = original(:, :, 2);
    blueBand = original(:, :, 3);
    %% Creat masks for different colors
    % Urab long distance color
    redThresholdLow = 150;
    redThresholdHigh = 180;
    greenThresholdLow = 140;
    greenThresholdHigh = 255;
    blueThresholdLow = 0;
    blueThresholdHigh = 255;
    % Now apply each color band's particular thresholds to the color band
    redMask = (redBand >= redThresholdLow) & (redBand <= redThresholdHigh);
    greenMask = (greenBand >= greenThresholdLow) & (greenBand <= greenThresholdHigh);
    blueMask = (blueBand >= blueThresholdLow) & (blueBand <= blueThresholdHigh);
    
    % houses color
        % Urab long distance color
    redThresholdLow_h = 155;
    redThresholdHigh_h = 197;
    greenThresholdLow_h = 115;
    greenThresholdHigh_h = 153;
    blueThresholdLow_h = 80;
    blueThresholdHigh_h = 118;
    % Now apply each color band's particular thresholds to the color band
    redMask_h = (redBand >= redThresholdLow_h) & (redBand <= redThresholdHigh_h);
    greenMask_h = (greenBand >= greenThresholdLow_h) & (greenBand <= greenThresholdHigh_h);
    blueMask_h = (blueBand >= blueThresholdLow_h) & (blueBand <= blueThresholdHigh_h);
    % Then we will have the mask of only the red parts of the image.
    binaryImage = uint8(redMask & greenMask & blueMask);
    binaryImage_h = uint8(redMask_h & greenMask_h & blueMask_h);
    binaryImage = binaryImage + binaryImage_h;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bw = im2bw(originalImage);
%stats = [regionprops(bw); regionprops(not(bw))];

%[rows, columns, numberOfColorChannels] = size(originalImage);
%%J = grayconnected(originalImage, 100, 50);
% Display the grayscale image.
%%edgeimg = edge(originalImage, 'sobel');
subplot(3, 3, 1);
%imshow(bw)
imshow(binaryImage, []);
%imshow(labeloverlay(originalImage,J));


% Display the binary image.
subplot(3, 3, 3);
imshow(binaryImage); 
title('Binary Image, obtained by thresholding', 'FontSize', captionFontSize); 

% Identify individual blobs by seeing which pixels are connected to each other.
% Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
% Do connected components labeling with either bwlabel() or bwconncomp().
labeledImage = bwlabel(binaryImage, 8);
labeledImage = imgaussfilt(labeledImage,2);
if contentType == 0
    % try to fill holes
    labeledImage = imfill(labeledImage,"holes");
end    
% binarize the now blurried image with filled holes 
labeledImage = imbinarize(labeledImage, 0.1);

%%Urban image
%urbanImag = imgaussfilt(urbanImag,1);    
% binarize the now blurried image with filled holes 
%urbanImag = imbinarize(urbanImag, 0.1);
%%vislabels(labeledImage),title('what is that');
%g = regionprops(labeledImage, 'Area', 'BoundingBox');
%g(1)
%area_values = [g.Area];
%idx= find(area_values >= 7000);
%h=  ismember(labeledImage,idx);
% labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
subplot(3, 3, 4);
imshow(labeledImage);  % Show the gray scale image.
title('Labeled Image, from bwlabel()', 'FontSize', captionFontSize);

% Let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'spring', 'b', 'shuffle'); % pseudo random color labels
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
subplot(3, 3, 5);
imshow(coloredLabels);
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
caption = sprintf('Pseudo colored labels');
title(caption, 'FontSize', captionFontSize);

% Get all the blob properties.
blobMeasurements = regionprops(labeledImage, originalImage, 'all');
zeroColorArea = regionprops(not(labeledImage),originalImage, 'all' );
numberOfBlobs = size(blobMeasurements, 1)
%numberofZeroAreas= size(zeroColorArea,1)

%UrbanBlobs = regionprops(urbanImag, originalImage, 'all');
subplot(3, 3, 7);
imshow(original);
[maxArea,max_index] = max([zeroColorArea.Area]);
max_centroid = cat(1,zeroColorArea(max_index).Centroid);
hold on
% Put the "blob number" labels on the "boundaries" grayscale image.
text(max_centroid(:,1), max_centroid(:,2), 'Sea', 'FontSize', 12, 'FontWeight', 'Bold', 'Color','red');

hold off



% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
subplot(3, 3, 6);
imshow(original);
title('Outlines, from bwboundaries()', 'FontSize', captionFontSize); 
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
boundaries = bwboundaries(labeledImage);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 2);
end

%% plot Urban area
%boundaries = bwboundaries(urbanImag);
%numberOfBoundaries = size(boundaries, 1);
%for k = 1 : numberOfBoundaries
%	thisBoundary = boundaries{k};
%	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 1);
%end
if contentType == 0
    %% Plot the Sea in the max zeroColor area
    [maxArea,max_index] = max([zeroColorArea.Area]);
    max_centroid_s = cat(1,zeroColorArea(max_index).Centroid);
    % Put the "blob number" labels on the "boundaries" grayscale image.
    text(max_centroid_s(:,1), max_centroid_s(:,2), 'Sea', 'FontSize', 12, 'FontWeight', 'Bold', 'Color','k');

    %% Plot The Empty earth
    [maxArea,max_index] = max([blobMeasurements.Area]);
    max_centroid_e = cat(1,blobMeasurements(max_index).Centroid);
    % Put the "blob number" labels on the "boundaries" grayscale image.
    text(max_centroid_e(:,1), max_centroid_e(:,2), 'Land', 'FontSize', 12, 'FontWeight', 'Bold', 'Color','k');    
else
    %% Plot The Empty earth
    [maxArea,max_index] = max([blobMeasurements.Area]);
    max_centroid_u = cat(1,blobMeasurements(max_index).Centroid);
    %Put the "blob number" labels on the "boundaries" grayscale image.
    text(max_centroid_u(:,1), max_centroid_u(:,2), 'Urban', 'FontSize', 12, 'FontWeight', 'Bold', 'Color','k');
end
hold off;



%%%%%%%%%%%
textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
labelShiftX = -7;	% Used to align the labels in the centers of the coins.
blobECD = zeros(1, numberOfBlobs);
% Print header line in the command window.
%%fprintf(1,'Blob #      Mean Intensity  Area   Perimeter    Centroid       Diameter\n');
% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfBlobs           % Loop through all blobs.
	% Find the mean of each blob.  (R2008a has a better way where you can pass the original image
	% directly into regionprops.  The way below works for all versions including earlier versions.)
	thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
	meanGL = mean(originalImage(thisBlobsPixels)); % Find mean intensity (in original image!)
	meanGL2008a = blobMeasurements(k).MeanIntensity; % Mean again, but only for version >= R2008a
	
	blobArea = blobMeasurements(k).Area;		% Get area.
	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
	blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
	% Put the "blob number" labels on the "boundaries" grayscale image.
	%%text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
end

% Now, I'll show you another way to get centroids.
% We can get the centroids of ALL the blobs into 2 arrays,
% one for the centroid x values and one for the centroid y values.
allBlobCentroids = [blobMeasurements.Centroid];
centroidsX = allBlobCentroids(1:2:end-1);
centroidsY = allBlobCentroids(2:2:end);
% Put the labels on the rgb labeled image also.
subplot(3, 3, 5);
for k = 1 : numberOfBlobs           % Loop through all blobs.
	%%text(centroidsX(k) + labelShiftX, centroidsY(k), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
end

% Now I'll demonstrate how to select certain blobs based using the ismember() function.
% Let's say that we wanted to find only those blobs
% with an intensity between 150 and 220 and an area less than 2000 pixels.
% This would give us the three brightest dimes (the smaller coin type).
allBlobIntensities = [blobMeasurements.MeanIntensity];
allBlobAreas = [blobMeasurements.Area];
% Get a list of the blobs that meet our criteria and we need to keep.
% These will be logical indices - lists of true or false depending on whether the feature meets the criteria or not.
% for example [1, 0, 0, 1, 1, 0, 1, .....].  Elements 1, 4, 5, 7, ... are true, others are false.
allowableIntensityIndexes = (allBlobIntensities > 150) & (allBlobIntensities < 220);
allowableAreaIndexes = allBlobAreas < 2000; % Take the small objects.
% Now let's get actual indexes, rather than logical indexes, of the  features that meet the criteria.
% for example [1, 4, 5, 7, .....] to continue using the example from above.
keeperIndexes = find(allowableIntensityIndexes & allowableAreaIndexes);
% Extract only those blobs that meet our criteria, and
% eliminate those blobs that don't meet our criteria.
% Note how we use ismember() to do this.  Result will be an image - the same as labeledImage but with only the blobs listed in keeperIndexes in it.
keeperBlobsImage = ismember(labeledImage, keeperIndexes);
% Re-label with only the keeper blobs kept.
labeledDimeImage = bwlabel(keeperBlobsImage, 8);     % Label each blob so we can make measurements of it
% Now we're done.  We have a labeled image of blobs that meet our specified criteria.
%subplot(3, 3, 7);
%imshow(labeledDimeImage, []);
%axis image;
%title('"Keeper" blobs (3 brightest dimes in a re-labeled image)', 'FontSize', captionFontSize);

% Plot the centroids in the original image in the upper left.
% Dimes will have a red cross, nickels will have a blue X.
message = sprintf('Now I will plot the centroids over the original image in the upper left.\nPlease look at the upper left image.');
reply = questdlg(message, 'Plot Centroids?', 'OK', 'Cancel', 'Cancel');
% Note: reply will = '' for Upper right X, 'OK' for OK, and 'Cancel' for Cancel.
if strcmpi(reply, 'Cancel')
	return;
end
subplot(3, 3, 1);
hold on; % Don't blow away image.
for k = 1 : numberOfBlobs           % Loop through all keeper blobs.
	% Identify if blob #k is a dime or nickel.
	itsADime = allBlobAreas(k) < 2200; % Dimes are small.
	if allBlobAreas(k)
		% Plot dimes with a red +.
		plot(centroidsX(k), centroidsY(k), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
	else
		% Plot dimes with a blue x.
		plot(centroidsX(k), centroidsY(k), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
	end
end


% Now use the keeper blobs as a mask on the original image.
% This will let us display the original image in the regions of the keeper blobs.
maskedImageDime = originalImage; % Simply a copy at first.
maskedImageDime(~keeperBlobsImage) = 0;  % Set all non-keeper pixels to zero.
subplot(3, 3, 8);
imshow(maskedImageDime);
axis image;
title('Only the 3 brightest dimes from the original image', 'FontSize', captionFontSize);


keeperIndexes = find(allBlobAreas > 2000);  % Take the larger objects.
nickelBinaryImage = ismember(labeledImage, keeperIndexes);

maskedImageNickel = originalImage; % Simply a copy at first.
maskedImageNickel(~nickelBinaryImage) = 0;  % Set all non-nickel pixels to zero.
subplot(3, 3, 9);
imshow(maskedImageNickel, []);
axis image;
title('original image', 'FontSize', captionFontSize);
%*******************************************************************************
left = [];
img_1 = reshape(originalImage, size(originalImage,1), size(originalImage,2), 1, 3);
img_2 = reshape(right, size(right,1), size(right,2), 1, 3);
left = cat(3, left, img_1);
left = cat(3, left, img_2);
size_left = size(left);
    
for i=1:size_left(3)
    left_tensor{i} = squeeze(left(:,:,i,:));
end
  
%% Crate a binary mask out of difference images
%Initialize average tensor with zeros
Iaverage_RGB_Tensor =zeros(size(left_tensor{1}));
% Create average tensor
for i = 1:size_left(3)
    Iaverage_RGB_Tensor = double(Iaverage_RGB_Tensor) + double(left_tensor{i})/size_left(3);
end

% get number of the middle image 
middle_Image_number = int8(size_left(3)/2);
% substract the middle tensor from the average Tensor and geht the abs
im_diff_RGB_tensor = abs(uint8(Iaverage_RGB_Tensor)-uint8(left_tensor{2}));
% convert RGB-Tensor to 
im_diff_grey = rgb2gray(im_diff_RGB_tensor);

%*********************************************************************************************

end