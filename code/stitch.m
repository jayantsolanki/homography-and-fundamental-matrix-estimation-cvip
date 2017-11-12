%stitch.m
%this code is used for performing image stitching of two images
function [result] = stitch(img1, img2, coor, harrisThreshold, deBug)
% Arguments:   
%            im1     			- image1 to be processed.
%            im2     			- image2 to be processed.
%            coor    			- just obtains inlier coordinates and return, 1 true, 0 for show stiched images
%            harrisThreshold    - specifying threshold for harris detector
%            deBug    			- show debugged images
%
% Returns:
%            result    - outputs the stiched images if coor = 0 else outputs the inliers coordinates for both images
	warning('off','all')
	neighbourhood_size = 5;%definging the neighbourhood size //optimum
	threshold = 3;%threshold for the dist2.m output, optimum
	% neighbourhood_size = 7;%definging the neighbourhood size
	% threshold = 3;%threshold for the dist2.m output
	if nargin < 5 %for debugging purpose
	    img1=imread('..\data\part1\uttower\left.jpg');
		img2=imread('..\data\part1\uttower\right.jpg');
		deBug = 0;
		harrisThreshold = 0.05;
		coor = 1;
	end
	im1=rgb2gray(img1);
	im2=rgb2gray(img2);
	im1=double(im1);%converting into double format
	im1=im1/255;
	im2=double(im2);%converting into double format
	im2=im2/255;
	[h, w] = size(im1);
	% imshow(im2)
	%%%%%%%%%%%%%%%%%%%%%%%%%% 1 - finding the feature points using harris blob detector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	disp('1 - Performing Harris corner detector trick.....')
	[cim,r,c] = harris(im1,2, harrisThreshold, 2, deBug);
	%%%%%%%%%%%%%%%%%%%%%%%% 2 - finding and storing the neighbourhood pixels for each feature points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[local_features1, coordinates1] = keypoints(im1, neighbourhood_size, r, c);
	% figure, imagesc(im1), axis image, colormap(gray), hold on
	% plot(C1,R1,'ys'), title('corners detected');
	% truesize;
	%%%%%%%%%%%%%%%%%%%%%%%%%% 1 - finding the feature points using harris blob detector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[~,r,c] = harris(im2,2, harrisThreshold, 2, deBug);
	%%%%%%%%%%%%%%%%%%%%%%%% 2 - finding and storing the neighbourhood pixels for each feature points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[local_features2, coordinates2] = keypoints(im2, neighbourhood_size, r, c);
	% figure, imagesc(im2), axis image, colormap(gray), hold on
	% plot(C2,R2,'ys'), title('corners detected');
	% imshow(cim)
	% truesize;
	%%%%%%%%%%%%%%%%%%%%%%%%% 3 - finding the euclidean distance between each keypoints of both images%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	disp('2 - Finding the putative matches and plotting them.....')
	n2 = dist2(local_features1, local_features2);
	[N,M] = find((n2<threshold)); %putative matches found
	Matches = size(N,1);
	% index = randperm(Matches,20) %randomly taking 20 putative matches
	% N = N(index, 1)
	% M = M(index, 1) 
	% 
	size(coordinates1);
	coordinates1=coordinates1(N,:);%STORING THE PUTATIVE MATCHES, x
	size(coordinates1);
	% C1=C1(unique(N,'first'), :);
	coordinates2=coordinates2(M,:);%STORING THE PUTATIVE MATCHES, Y
	size(coordinates2);
	if deBug ==1
		stackedImage = cat(2, im1, im2); % Places the two images side by side, %courtesy stackoverflow.com
		figure; clf; imshow(stackedImage); hold on;
		% show features detected in image 1
		plot(coordinates1(:,1),coordinates1(:,2),'+m');
		plot(coordinates2(:,1)+w,coordinates2(:,2),'oc');
		% show displacements
		% line([coordinates1(:,1); coordinates2(:,1)],[coordinates1(:,2); coordinates2(:,2)],'color','y');
		for i = 1 : size(coordinates2)
			line([coordinates1(i, 1) (coordinates2(i, 1)+w)], [coordinates1(i, 2) coordinates2(i, 2)], 'Color', 'yellow');
			end
		title('3 - Plotting the Putative Matches.....'); %plotting putative matches
		truesize;
	end
	

	% C2=C2(unique(M,'first'));
	% figure, imagesc(im1), axis image, colormap(gray), hold on
	% plot(coordinates1(:,2),coordinates1(:,1),'ys'), title('corners detected');
	% figure, imagesc(im2), axis image, colormap(gray), hold on
	% plot(coordinates2(:,2),coordinates2(:,1),'ys'), title('corners detected');

	%%%%%%%%%%%%%%%%%%%%%%%%% 4 - Applying RANSAC to remove outliers and get optimum Homogrpahy Matrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	disp('4 - Performing very Simple RANSAC algorithm and plotting the inliers.....')
	[H, inliers, residual_error] = ransac(coordinates1, coordinates2, 20000);
	if deBug ==1
		stackedImage = cat(2, im1, im2); % Places the two images side by side, %courtesy stackoverflow.com
		figure; clf; imshow(stackedImage); hold on;
		% show features detected in image 1
		plot(coordinates1(inliers,1),coordinates1(inliers, 2),'+m');
		plot(coordinates2(inliers,1)+w,coordinates2(inliers, 2),'oc');
		% show displacements
		% line([coordinates1(:,1); coordinates2(:,1)],[coordinates1(:,2); coordinates2(:,2)],'color','y');
		coordinates11 = coordinates1(inliers,:);
		coordinates22 = coordinates2(inliers,:);
		for i = 1 : size(coordinates22)
			line([coordinates11(i, 1) (coordinates22(i, 1)+w)], [coordinates11(i, 2) coordinates22(i, 2)], 'Color', 'yellow');
		end
		title('5 - Plotting inliers after removing the outliers from the putative matches.....');%plotitng inliers
		truesize;
	end
	
	disp('6 - Some useful data.....')
	fprintf('Residual Error in inliers: %0.3f \n',residual_error);
	fprintf('Number of Inliers out of %d Putative pairs: %d \n', length(coordinates1),length(inliers) );
	if length(inliers) <4 %exit if too many outliers
		disp('Second image is an outlier, too few matches')
		return
	end
	if coor == 0
		result = [];
		result = [coordinates1(inliers,:) coordinates2(inliers,:)];
		return
	end
	% showMatchedFeatures(im1,im2,coordinates1,coordinates2) %%using computer toolbox, debugging
	%%%%%%%%%%%%%%%%%%%%%%%%% 5 - Perfomring image stiching using the Homography matrix H%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	disp('7 - Finally showing the stiched images')
	result = panO(img1, img2, H);
	% figure;
	% clf;
	% imshow(result);
	% hold on;
	% title('Stitched Images');
	H
	disp('Hurray!!!!!')


