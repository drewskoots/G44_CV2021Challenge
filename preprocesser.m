function [imageSet] = preprocesser(Path)
%UNTITLED this function takes set of images and preprocess them for the
%feature detecting
%   it takes the folder path and the name of the detector as inputs and
%   then convert them to grayscale and apply adaptive threshhollding then
%   gausian kernal to reduce the noise. it gives back set of preprocessed
%   images. 
imds = imageDatastore(Path,'LabelSource', 'foldernames');
numberOfImages = length(imds.Files);
for k = 1 : numberOfImages
  % Get the input filename.  It already has the folder prepended so we don't need to worry about that.
  inputFileName = imds.Files{k};
  [rgbImage,info] = read(inputFileName);
  grayImage = rgb2gray(rgbImage);
  filteredImage = imgaussfilt(grayImage);
  T = adaptthresh(filteredImage, 0.4);
  BW = imbinarize(filteredImage,T);
  imwrite(BW,info.Filename);
  
end
imageSet = imds;

