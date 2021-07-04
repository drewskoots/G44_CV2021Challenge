function [outImage] = preprocesser(inImage)
%UNTITLED this function takes set of images and preprocess them for the
%feature detecting
%   it takes the folder path and the name of the detector as inputs and
%   then convert them to grayscale and apply adaptive threshhollding then
%   gausian kernal to reduce the noise. it gives back set of preprocessed
%   images. 


  grayImage = rgb2gray(inImage);
  filteredImage = imgaussfilt(grayImage);
  T = adaptthresh(filteredImage, 0.4);
  Binary = imbinarize(filteredImage,T);
  outImage = uint8(255 * Binary);


