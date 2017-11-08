%panO.m
%this code is used for performing image stitching of two images
function [result] = panO(im1, im2, H, inliers, coordinates1, coordinates2)
% Arguments:   
%            im1     	  - image1 to be tranformed based upon the homography matrix H
%            im2     	  - image2 to be stiched with transformed image 1.
%            H       	  - transformation matrix calculated using Harris detector and RANSAC algo
%            inliers 	  - indices of the true matching point detected in the image 1, that is the inliers
%            coordinates1 - coordinates of the all feature vectors in the im1
%            coordinates2 - coordinates of the all feature vectors in the im2
%
% Returns:
%            result    - outputs the stiched images
    [h,w] = size(im1);
    [hh, ww] = size(im2)
	% tform = maketform('projective',H');%had to inverse and transpose the H, it works different here campared to general matrix transformation
	% % homoTrans = maketform('projective', H)
	% out_size = [h w];
	% aee = zeros(2000, 2000);
	% % aee(1:h,1:w) = im1;
	% result = imtransform(im1, tform, 'nearest');
	% % [h, w] = size(result);
	% coordinates1(inliers,:);
	% inputs = [coordinates1(inliers,:)';ones(1,length(inliers))]; %adding the homogeneous column
	% inputs_trans = H*inputs;
	% inputs_trans = inputs_trans';
	% tempInputs = inputs_trans(:,1:2);
 %    tempInputs(:,1)=tempInputs(:,1)./inputs_trans(:,3);%normalising the column with the homogneous column, w
 %    tempInputs(:,2) = tempInputs(:,2)./inputs_trans(:,3);%normalising the column with the homogneous column, w
 %    inputs_trans = round(tempInputs);
 %    % sort(inputs_trans,2)
 %    X = [1, w; round(h/2), w; h, w]
 %    Xdash = H*[X';ones(1,3)];
 %    Xdash = Xdash';
 %    Xtemp = Xdash(:,1:2);
 %    Xtemp(:,1)=Xtemp(:,1)./Xdash(:,3);
 %    Xtemp(:,2)=Xtemp(:,2)./Xdash(:,3);
 %    Xdash = round(Xtemp)

 	[im11, xdata, ydata] = imtransform(im1,maketform('projective',inv(H')));
 	[h11, w11] = size(im11)
 	hh
 	ww
xdata
ydata
    xdata_out=[min(1,xdata(1)) max(size(im2,2), xdata(2))]; %width
    ydata_out=[min(1,ydata(1)) max(size(im2,1), ydata(2))]; %depth
    xoffset = xdata_out(2) - xdata_out(1)
    yoffset = ydata_out(2) - ydata_out(1)
xdata_out
ydata_out
    result1 = imtransform(im1, maketform('projective',inv(H')),...
             'XData',xdata_out,'YData',ydata_out);
    result2 = imtransform(im2, maketform('affine',eye(3)),...
             'XData',xdata_out,'YData',ydata_out);
    result = result1 + result2;
    overlap = (result1 > 0.0) & (result2 > 0.0);
    result_avg = (result1/2 + result2/2);
    
    result(overlap) = result_avg(overlap);
    figure; imshow(result);
    size(result1)




end