function [outImage] = preprocesser(inImage)
%UNTITLED this function takes set of images and preprocess them for the
%feature detecting
%   it takes the folder path and the name of the detector as inputs and
%   then convert them to grayscale and apply adaptive threshhollding then
%   gausian kernal to reduce the noise. it gives back set of preprocessed
%   images. 

%convert the image to grayscale
  grayImage = rgb2gray(inImage);
%filter image using adaptive threshholding
%   T = adaptthresh(grayImage, 0.4);
%   Binary = imbinarize(grayImage,T);
% 
% %  using Gaussian filter
%   unit8Image = uint8(255 * Binary);
%   filteredImage = imgaussfilt(unit8Image);
%   outImage = uint8(255 * filteredImage);


