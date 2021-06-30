function diff_image(app)
%DIFF_IMAGE Displays a diff image visualization in the UI image viewer.

%Load info about all images from source folder
imageFiles=dir([app.target_folder '/*.jpg']);
n_images=length(imageFiles);


%set first image in folder as first in a cell array
first_im=imread(fullfile(app.target_folder,imageFiles(1).name));
second_im=imread(fullfile(app.target_folder,imageFiles(2).name));


gray_first=rgb2gray(first_im);
gray_second=rgb2gray(second_im);

[tform,~]=register(gray_first, gray_second,app.surf_flag);

second_im_reg=imwarp(second_im,tform,'OutputView',imref2d(size(first_im,[1 2])));

[~,ssimmap]=ssim(second_im_reg,first_im);
imagesc(app.ImageAxes,ssimmap);

end

