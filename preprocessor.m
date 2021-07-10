function [outImage] = preprocessor(inImage)
% this function takes an input images and preform a set of processes on it to enhance the feature detecting and segmantation
% input is rgb image 
% output is grayscale filtered image
%  processes are: gamma correction, conversion to grayscle, contrast enhancment, and filtering the image to discard the noise 
%Author:Esam Hassan

% %Gamma correction
outImage = lin2rgb(inImage);

%convert the image to grayscale
if size(inImage,3)~=1
   outImage = rgb2gray(outImage); 
end

%contrast enhancment
 outImage = adapthisteq(outImage);
% 
% %filtering the image
sigma = 30;
outImage = imflatfield(outImage,sigma);
