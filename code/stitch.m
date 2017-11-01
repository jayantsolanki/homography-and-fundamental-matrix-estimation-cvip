%stitch.m
%this code is used for performing image stitching of two images
function stitch(im1, im2, thresh)
	%% im1 is the first image
	%% im2 is the second image
	%% thresh is the threshold for putative matches
	neighbourhood_size = 9;%definging the neighbourhood size
	if nargin < 3 %for debugging purpose
	    im1=imread('..\data\part1\uttower\left.jpg');
		im2=imread('..\data\part1\uttower\right.jpg');
	end
	im1=rgb2gray(im1);
	im2=rgb2gray(im2);
	[h, w] = size(im1);
	% imshow(im2)
	%%%%%%%%%%%%%%%%%%%%%%%%%% 1 - finding the feature points using harris blob detector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[cim,r,c] = harris(im1,2,1000, 2, 1);
	%%%%%%%%%%%%%%%%%%%%%%%% 2 - finding and storing the neighbourhood pixels for each feature points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	local_features1 = keypoints(im1, neighbourhood_size, r, c);
	size(local_features1)
	truesize;
	%%%%%%%%%%%%%%%%%%%%%%%%%% 1 - finding the feature points using harris blob detector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[cim,r,c] = harris(im2,2,1000, 2, 1);
	%%%%%%%%%%%%%%%%%%%%%%%% 2 - finding and storing the neighbourhood pixels for each feature points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	local_features2 = keypoints(im2, neighbourhood_size, r, c);
	size(local_features2)
	% imshow(cim)
	truesize;
	%%%%%%%%%%%%%%%%%%%%%%%%% 3 - finding the euclidean distance between each keypoints of both images%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	n2 = dist2(local_features1, local_features2);
	size(n2)
	(n2<100)
