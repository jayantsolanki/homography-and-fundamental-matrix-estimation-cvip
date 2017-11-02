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
	[cim,r,c] = harris(im1,2, 1000, 2, 1);
	%%%%%%%%%%%%%%%%%%%%%%%% 2 - finding and storing the neighbourhood pixels for each feature points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[local_features1, coordinates1] = keypoints(im1, neighbourhood_size, r, c);
	% figure, imagesc(im1), axis image, colormap(gray), hold on
	% plot(C1,R1,'ys'), title('corners detected');
	size(local_features1)
	size(coordinates1)
	truesize;
	%%%%%%%%%%%%%%%%%%%%%%%%%% 1 - finding the feature points using harris blob detector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[cim,r,c] = harris(im2,2, 1000, 2, 1);
	%%%%%%%%%%%%%%%%%%%%%%%% 2 - finding and storing the neighbourhood pixels for each feature points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[local_features2, coordinates2] = keypoints(im2, neighbourhood_size, r, c);
	size(local_features2)
	% figure, imagesc(im2), axis image, colormap(gray), hold on
	% plot(C2,R2,'ys'), title('corners detected');
	size(coordinates2)
	% imshow(cim)
	truesize;
	%%%%%%%%%%%%%%%%%%%%%%%%% 3 - finding the euclidean distance between each keypoints of both images%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	n2 = dist2(local_features1, local_features2);
	size(n2)
	[N,M] = find((n2<7)) %putative matches found
	Matches = size(N,1)
	% index = randperm(Matches,20) %randomly taking 20 putative matches
	% N = N(index, 1)
	% M = M(index, 1) 
	% 
	size(M)
	size(N)

	size(coordinates1)
	coordinates1=coordinates1(N,:);
	size(coordinates1)
	% C1=C1(unique(N,'first'), :);
	coordinates2=coordinates2(M,:);
	size(coordinates2)
	% stackedImage = cat(2, im1, im2); % Places the two images side by side, %courtesy stackoverflow.com
	% figure; clf; imshow(stackedImage); hold on;
	% % show features detected in image 1
	% plot(coordinates1(:,1),coordinates1(:,2),'+m');
	% plot(coordinates2(:,1)+w,coordinates2(:,2),'oc');
	% % show displacements
	% % line([coordinates1(:,1); coordinates2(:,1)],[coordinates1(:,2); coordinates2(:,2)],'color','y');
	% for i = 1 : size(coordinates2)
	% 	line([coordinates1(i, 1) (coordinates2(i, 1)+w)], [coordinates1(i, 2) coordinates2(i, 2)], 'Color', 'yellow');

	% 	end
	% % showMatchedFeatures(im1,im2,coordinates1,coordinates2) %%using computer toolbox, debugging
	% truesize;

	% C2=C2(unique(M,'first'));
	% figure, imagesc(im1), axis image, colormap(gray), hold on
	% plot(coordinates1(:,2),coordinates1(:,1),'ys'), title('corners detected');
	% figure, imagesc(im2), axis image, colormap(gray), hold on
	% plot(coordinates2(:,2),coordinates2(:,1),'ys'), title('corners detected');
	[H] = ransac(coordinates1, coordinates2, 1000);
	H(9,1) = 1;
	H = reshape(H, 3,3, []);

