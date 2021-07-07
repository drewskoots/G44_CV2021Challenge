function [imageCellArray, nameCellArray] = loadData(target_folder, surf_flag)
%LOADDATA gets all image names, preprocesses and then registers images and aligns them to the
%orientation of the first image.


%load image data from directory
imageFiles=dir([target_folder '/*.jpg']);
n_images=length(imageFiles);
nameCellArray={imageFiles.name};
imageCellArray{n_images}=[];


%set first image in folder as first element of cell array and greyscale it
%if neccessary
imageCellArray{1}=imread(fullfile(target_folder,imageFiles(1).name));

if size(imageCellArray{1},3)~=1
    ref_image=rgb2gray(imageCellArray{1});
    
else
    ref_image=imageCellArray{1};
end

for k = 2 : n_images
    
    %read next image to register
    fullFileName = fullfile(target_folder, imageFiles(k).name);
    current_image= imread(fullFileName);
    
    if surf_flag
        preprocesser(current_image,ref_image);
    else
        %Match curerent image histograms to the first image (ref_image)
        current_image_corr=imhistmatch(current_image,ref_image);
        %TODO: add preprocess step!
        
        
        %grayscale image if it isn't already
        if size(current_image_corr,3)~=1
            gray_image=rgb2gray(current_image_corr);
            
        else
            gray_image=current_image_corr;
        end
        
    end
   
    [tform, error_flag]=register(ref_image,gray_image,surf_flag);
   
    %error handling: if image could not be registered, discard it and its
    %name, otherwise save the registered image
    if error_flag
        fig = uifigure;
        msg=sprintf('The image "%s" could not be registered. It will not be included in the visualisations.',nameCellArray{k});
        uialert(fig,'msg','Registration Error');
        imageCellArray{k}=[];
        nameCellArray{k}=[];
    else
        imageCellArray{k}=imwarp(current_image,tform,'OutputView',imref2d(size(ref_image,[1 2])));
    end
end


end

