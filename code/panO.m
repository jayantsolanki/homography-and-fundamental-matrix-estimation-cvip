%panO.m
%this code is used for performing image stitching of two images
function [result] = panO(im1, im2, H)
% Arguments:   
%            im1     	  - image1 to be tranformed based upon the homography matrix H
%            im2     	  - image2 to be stiched with transformed image 1.
%            H       	  - transformation matrix calculated using Harris detector and RANSAC algo
%
% Returns:
%            result    - outputs the stiched images
 %referenced from http://www.leet.it/home/giusti/teaching/matlab_sessions/stitching/stitch.html
 	warning('off','all')
 	[im11, xdata, ydata] = imtransform(im1,maketform('projective',H'));
    xdata_out=[min(1,xdata(1)) max(size(im2,2), xdata(2))]; %width
    ydata_out=[min(1,ydata(1)) max(size(im2,1), ydata(2))]; %depth
    result1 = imtransform(im1, maketform('projective',H'),...
             'XData',xdata_out,'YData',ydata_out);
    result2 = imtransform(im2, maketform('affine',eye(3)),...
             'XData',xdata_out,'YData',ydata_out);
    % result = result1 + result2;
    % overlap = (result1 > 0.0) & (result2 > 0.0);
    % result_avg = (result1/2 + result2/2);
    result=max(result1,result2);
    
    % result(overlap) = result_avg(overlap);
    % figure; imshow(result);




end