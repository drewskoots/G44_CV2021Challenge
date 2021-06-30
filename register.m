function [tform, registered_image] = register(reference_image,moved_image, surf_flag)
%REGISTER: aligns 2 images of the same object that have been rotated,
%translated or scaled.

%@Input: reference_image, the first image thatshould be compared against
%@Input: moved_image, the image that should be aligned to the same
%orientation as reference_image
%@Input: surf_flag true/false if SURF should be used instead of KAZE


%detect features via surf/KAZE depending on what option is passed to surf_flag
if surf_flag
    points1= detectSURFFeatures(reference_image);
    points2= detectSURFFeatures(moved_image);
else
    points1= detectKAZEFeatures(reference_image);
    points2= detectKAZEFeatures(moved_image);
end

%extract features from detected points via BRISK
[features1,valid_points1] = extractFeatures(reference_image,points1,'Method', 'BRISK');
[features2,valid_points2] = extractFeatures(moved_image,points2,'Method', 'BRISK');


%match corresponding features
if size(valid_points1,1)>5000 || size(valid_points2,1)>5000
    index=matchFeatures(features1,features2,'MatchThreshold',25.0,'MaxRatio',0.6, 'Method', 'Approximate');
else
    index=matchFeatures(features1,features2,'MatchThreshold',25.0,'MaxRatio',0.6);
end

%of the detected points, only select the matched ones.
matchedPoints1 = valid_points1(index(:,1));
matchedPoints2 = valid_points2(index(:,2));


%Show the matching features and how the computer thinks they moved
% figure
 %showMatchedFeatures(original,rotated,matchedPoints1,matchedPoints2);

%fit a transform between the points
%try
   tform = fitgeotrans(matchedPoints2.Location,matchedPoints1.Location,'NonreflectiveSimilarity');
% catch exception
%    pass
% end




%apply the transform to the rotated image 
registered_image = imwarp(moved_image,tform,'OutputView',imref2d(size(reference_image)));

%show how the reconstructed image and the first one line up.
%  figure
%  imshowpair(reference_image, registered_image,'diff');
end

