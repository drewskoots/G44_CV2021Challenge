function [tform, registered_image] = register(reference_image,moved_image, relax_flag)
%% Register images and align

%relax matching criteria if hard to match
if relax_flag==0
    match_threshold=10;
    max_ratio=0.6;
elseif relax_flag==1
    match_threshold=25;
    max_ratio=0.75;
end


%detect features via surf and extract feature descriptors via BRISK
points1= detectKAZEFeatures(reference_image);
points2= detectKAZEFeatures(moved_image);

[features1,valid_points1] = extractFeatures(reference_image,points1,'Method', 'BRISK');
[features2,valid_points2] = extractFeatures(moved_image,points2,'Method', 'BRISK');


%match corresponding features
if size(valid_points1,1)>5000 || size(valid_points2,1)>5000
    index=matchFeatures(features1,features2,'MatchThreshold',25.0,'MaxRatio',0.6, 'Method', 'Approximate');
else
    index=matchFeatures(features1,features2,'MatchThreshold',25.0,'MaxRatio',0.6);
end


matchedPoints1 = valid_points1(index(:,1));
matchedPoints2 = valid_points2(index(:,2));

%Show the matching features and how the computer thinks they moved
% figure
% showMatchedFeatures(original,rotated,matchedPoints1,matchedPoints2);

%fit a transform between the points, then find the invers of it
tform = fitgeotrans(matchedPoints2.Location,matchedPoints1.Location,'NonreflectiveSimilarity');


%apply the inverse to the rotated image 
registered_image = imwarp(moved_image,tform,'OutputView',imref2d(size(reference_image)));

%show how the reconstructed image and the first one line up.
%  figure
%  imshowpair(reference_image, registered_image,'diff');
end

