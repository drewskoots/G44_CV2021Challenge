function [image_Array, time_lapse] = timelapse(target_folder)
%TIMELAPSE Summary of this function goes here
%   Detailed explanation goes here

imageFiles=dir([target_folder '/*.jpg']);
n_images=length(imageFiles);
image_Array{n_images}=[];

image_Array{1}=imread(fullfile(target_folder,imageFiles(1).name));
time_lapse(1)=im2frame(image_Array{1});
%open each image in target_folder, and process it
for k = 2 : n_images
    
    ref_image=rgb2gray(image_Array{1});
    
    fullFileName = fullfile(target_folder, imageFiles(k).name);
    color_image= imread(fullFileName);
    

    %TODO: add preprocess step!
    %Match curerent image histograms to the first image (ref_image)
    current_image_corr=imhistmatch(color_image,ref_image);
    
    %grayscale image if it isn't already
    if size(current_image_corr,3)~=1
        gray_image=rgb2gray(current_image_corr);

    else
        gray_image=current_image_corr;
    end
    
    
    [tform, ~]=register(ref_image,gray_image,0);
    
    image_Array{k}=imwarp(color_image,tform,'OutputView',imref2d(size(ref_image,[1 2])));
    
    time_lapse(k)=im2frame(image_Array{k});
end
end

