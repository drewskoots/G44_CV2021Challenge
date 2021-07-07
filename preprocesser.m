function [outImage] = preprocesser(inImage)
%UNTITLED this function takes set of images and preprocess them for the
%feature detecting
%   it takes the folder path and the name of the detector as inputs and
%   then convert them to grayscale and apply adaptive threshhollding then
%   gausian kernal to reduce the noise. it gives back set of preprocessed
%   images. 
%Gamma correction
outImage = = lin2rgb(inImage);

%contrast enhancment
outImage = = adapthisteq(outImage);

%convert the image to grayscale
outImage = rgb2gray(outImage);
  


%filtering the image
sigma = 30;
outImage = imflatfield(outImage,sigma);






