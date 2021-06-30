function timelapse(app)
%TIMELAPSE: creates and displays a timelapse in the image viewer of the app.


%loads all images from the selected directory and preallocates a cell array
%of the same size.
imageFiles=dir([app.target_folder '/*.jpg']);
n_images=length(imageFiles);
image_Array{n_images}=[];

%set first image in folder as first
image_Array{1}=imread(fullfile(app.target_folder,imageFiles(1).name));
time_lapse(1)=im2frame(image_Array{1});

%open each image in target_folder, and process it
for k = 2 : n_images
    
    ref_image=rgb2gray(image_Array{1});
    
    fullFileName = fullfile(app.target_folder, imageFiles(k).name);
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
    
    
    [tform, ~]=register(ref_image,gray_image,app.surf_flag);
    
    image_Array{k}=imwarp(color_image,tform,'OutputView',imref2d(size(ref_image,[1 2])));
    
end 

app.StatusField.Value='Playing timelapse. End playback to continue';

while(~app.EndPlaybackButton.Value)
    
    for i=1:n_images
        if app.EndPlaybackButton.Value
            break
        end
        imagesc(app.ImageAxes,image_Array{i});
        pause(1/app.FPSField.Value);   % pause for between images to achieve desired fps
    end
    
end
    app.EndPlaybackButton.Value=false;

end

