%%FILE I/O SECTION

%Start UI from main.m file
app=UI();

% %find all image files in the target_folder and count how many there are
imageFiles=dir([target_folder '/*.jpg']);
n_images=length(imageFiles);


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

    %grayscale image if it isn't already
    if size(current_image_corr,3)~=1
        gray_image=rgb2gray(current_image_corr);
    else
        gray_image=current_image_corr;
    end



    imageArray(:,:,k)=gray_image;

end

%% Register images and align

%detect features via surf and extract feature descriptors via BRISK
points1= detectSURFFeatures(original);
points2= detectSURFFeatures(rotated);

[features1,valid_points1] = extractFeatures(original,points1,'Method', 'BRISK');
[features2,valid_points2] = extractFeatures(rotated,points2,'Method', 'BRISK');


%match corresponding features
index=matchFeatures(features1,features2,'MatchThreshold',25.0,'MaxRatio',0.7);

matchedPoints1 = valid_points1(index(:,1));
matchedPoints2 = valid_points2(index(:,2));

%Show the matching features and how the computer thinks they moved
figure
showMatchedFeatures(original,rotated,matchedPoints1,matchedPoints2);

%fit a transform between the points, then find the invers of it
tform = fitgeotrans(matchedPoints2.Location,matchedPoints1.Location,'NonreflectiveSimilarity');
inv_tform=invert(tform);

%apply the inverse to the rotated image 
rot_registered = imwarp(rotated,tform,'OutputView',imref2d(size(original)));

%show how the reconstructed image and the first one line up.
figure
im=imshowpair(original, rot_registered,'diff')

