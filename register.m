function [registered_image] = register(reference_image,moved_image)
%% Register images and align

%detect features via surf and extract feature descriptors via BRISK
points1= detectSURFFeatures(original);
points2= detectSURFFeatures(rotated);

[features1,valid_points1] = extractFeatures(original,points1,'Method', 'BRISK');
[features2,valid_points2] = extractFeatures(rotated,points2,'Method', 'BRISK');


%match corresponding features
index=matchFeatures(features1,features2,'MatchThreshold',25.0,'MaxRatio',0.6);

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
imshowpair(original, rot_registered,'diff');
end

