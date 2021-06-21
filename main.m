%%FILE I/O SECTION

%TODO: This Folder location and subfolder will need to be an input coming from
%the GUI!

base_path='./Datasets';
sub_folders=dir(base_path);



location='Frauenkirche'; %This will also have to be User selectable

target_folder=fullfile(base_path,location);

if ~isdir(target_folder)
  errorMessage = sprintf('Error: The target folder does not exist:\n%s', target_folder);
  uiwait(warndlg(errorMessage));
  return;
end



%find all image files in the target_folder and count how many there are
imageFiles=dir([target_folder '/*.jpg']);
n_images=length(imageFiles);

features={};
valid_points={};
%open each image in target_folder, and process it
for k = 1 : n_images
    %% IMAGE LOADING AND PREPROCESSING
    baseFileName = imageFiles(k).name;
    fullFileName = fullfile(imageFiles(k).folder, baseFileName);
    
    current_image= imread(fullFileName);
    
    if k==1
        ref_image=current_image;
    end
    
    %Match curerent image histograms to the first image (ref_image)
    current_image_corr=imhistmatch(current_image,ref_image);
    
    if size(current_image_corr,3)~=1
        gray_image=rgb2gray(current_image_corr);
    else
        gray_image=current_image_corr;
    end
    
    
    
    imageArray(:,:,k)=gray_image;
    
    %% Extract Features from image
    points=detectORBFeatures(gray_image);
    
    [features,validPoints(:,;,k)] = extractFeatures(gray_image,points,'Method', 'ORB');
    
end



