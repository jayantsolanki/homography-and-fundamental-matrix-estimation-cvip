%%
%% load images and match files for the first example
%%

% I1 = imread('..\data\part2\library1.jpg');
% I2 = imread('..\data\part2\library2.jpg');
% matches = load('..\data\part2\library_matches.txt'); 

I1 = imread('..\data\part2\house1.jpg');
I2 = imread('..\data\part2\house2.jpg');
matches = load('..\data\part2\house_matches.txt'); 
% this is a N x 4 file where the first two numbers of each row
% are coordinates of corners in the first image and the last two
% are coordinates of corresponding corners in the second image: 
% matches(i,1:2) is a point in the first image
% matches(i,3:4) is a corresponding point in the second image

N = size(matches,1);

%%
%% display two images side-by-side with matches
%% this code is to help you visualize the matches, you don't need
%% to use it to produce the results for the assignment
%%
imshow([I1 I2]); hold on;
plot(matches(:,1), matches(:,2), '+r');
plot(matches(:,3)+size(I1,2), matches(:,4), '+r');
line([matches(:,1) matches(:,3) + size(I1,2)]', matches(:,[2 4])', 'Color', 'r');
disp('Code paused, please press Escape to continue');
pause;

%%
%% display second image with epipolar lines reprojected 
%% from the first image
%%

% first, fit fundamental matrix to the matches
F = fit_fundamental(matches); % this is a function that i had written
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Epipolar lines on 1st image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = (F' * [matches(:,3:4) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,1:2) ones(N,1)],2);
closest_pt = matches(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
%finding the residual distance
error = sum((closest_pt-matches(:,1:2)).^2,2);
fprintf('In first image, Residual distance in pixels is %0.3f \n',mean(error));%printing the residual error

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure;
clf;
imshow(I1); hold on;
plot(matches(:,1), matches(:,2), '+r');
line([matches(:,1) closest_pt(:,1)]', [matches(:,2) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
title('Plotting the epipolar lines on the Ground truths in First Image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Epipolar Lines on second image#########################################
L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
%finding the residual distance
error = sum((closest_pt-matches(:,3:4)).^2,2);
fprintf('In second image, Residual distance in pixels is %0.3f \n',mean(error));%printing the residual error

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure;
clf;
imshow(I2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
title('Plotting the epipolar lines on the Ground truths in Second Image');
% return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Start of Part 2-3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Execution paused, press escape to close all the exisiting image figure and continue execution')
pause;
close all;%closes all the opened figures
%%%%%%%%%%%%%%%%%%%%%%%%%Now using the stitch method created for the Part 1 to get the inliers%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Getting putative match from the code used in the part 1 stitch');
matches = stitch(I1, I2, 0, 0.005, 0);%getting the inliers
N = size(matches,1);
%%
%% display two images side-by-side with matches
%% this code is to help you visualize the matches, you don't need
%% to use it to produce the results for the assignment
%%
% imshow([I1 I2]); hold on;
% plot(matches(:,1), matches(:,2), '+r');
% plot(matches(:,3)+size(I1,2), matches(:,4), '+r');
% line([matches(:,1) matches(:,3) + size(I1,2)]', matches(:,[2 4])', 'Color', 'r');
% pause;

F = fit_fundamental(matches); % this is a function that i had written
L = (F' * [matches(:,3:4) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,1:2) ones(N,1)],2);
closest_pt = matches(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
%finding the residual distance
error = sum((closest_pt-matches(:,1:2)).^2,2);
fprintf('In first image, Residual distance in pixels is %0.3f \n',mean(error));%printing the residual error

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure;
clf;
imshow(I1); hold on;
plot(matches(:,1), matches(:,2), '+r');
line([matches(:,1) closest_pt(:,1)]', [matches(:,2) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
title('Plotting the epipolar lines on the putative matches in First Image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Epipolar Lines on second image#########################################
L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
%finding the residual distance
error = sum((closest_pt-matches(:,3:4)).^2,2);
fprintf('In second image, Residual distance in pixels is %0.3f \n',mean(error));%printing the residual error

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure;
clf;
imshow(I2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
title('Plotting the epipolar lines on the putative matches in Second Image');
disp('Execution paused, press escape to close all the exisiting image figure and continue execution')
pause;
close all;%closes all the opened figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Start of Part 2-4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P1 = load('..\data\part2\house1_camera.txt'); %camera 1 projection matrix
P2 = load('..\data\part2\house2_camera.txt'); %camera 2 projection matrix
[P1U,P1D,P1V] = svd(P1);
[P2U,P2D,P2V] = svd(P2);
C1 = P1V(:,end)';%camera 1 coordinates
C2 = P2V(:,end)';%camera 2 coordinates
C1(1,1) = C1(1,1)/C1(1,4);
C1(1,2) = C1(1,2)/C1(1,4);
C1(1,3) = C1(1,3)/C1(1,4);
C1= C1(1,1:3);
C2(1,1) = C2(1,1)/C2(1,4);
C2(1,2) = C2(1,2)/C2(1,4);
C2(1,3) = C2(1,3)/C2(1,4);
C2= C2(1,1:3);

matches = load('..\data\part2\house_matches.txt'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Performing Triangulation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XY = zeros(length(matches),2);
Z = zeros(length(matches),3);
xy__ = zeros(length(matches),2);
for i=1:length(matches)
	A = [matches(i,1)*P1(3,:) - P1(1,:);
	 matches(i,2)*P1(3,:) - P1(2,:);
	 matches(i,3)*P2(3,:) - P2(1,:);
	 matches(i,4)*P2(3,:) - P2(2,:);];
	 [U,D,V] = svd(A);
	 X = V(:,end);
	 tempXY =  X;
	 tempXY(1,1)=tempXY(1,1)/X(4,1);%normalising the row with the homogneous column, w
     tempXY(2,1) = tempXY(2,1)/X(4,1);%normalising the column with the homogneous column, w
     tempXY(3,1)=tempXY(3,1)/X(4,1);%normalising the row with the homogneous column, w
     X(4,1) = 1;
     X = tempXY;
     Z(i,:) = X(1:3,1)';
     % X
	 % size(X)
	 % break
	 % P1\X(1:3,1)
	 temp1 = (P1*X)';
	 temp2 = (P2*X)';
	 temp11 = temp1;
	 temp22 = temp2;
	 temp11(1,1) = temp1(1,1)/temp1(1,3);
	 temp22(1,1) = temp2(1,1)/temp2(1,3);
	 temp1 = temp11;
	 temp2 = temp22;
	 XY(i,:) = temp1(1,1:2);
	 xy__(i,:) = temp2(1,1:2);
end
% size(Z1)
errorXY = mean(sum((XY(:,:)-matches(:,1:2)).^2,2));
errorxy__ = mean(sum((xy__(:,:)-matches(:,3:4)).^2,2));
fprintf('Residual error for 2-D coordinates in First Image is : %0.3f \n', errorXY);
fprintf('Residual error for 2-D coordinates in Second Image is : %0.3f \n', errorxy__);
figure;
clf;
hold on;
plot3(C1(:,1),C1(:,2),C1(:,3),'+m');
plot3(C2(:,1),C2(:,2),C2(:,3),'+C');
plot3(Z(:,1),Z(:,2),Z(:,3),'ob');
axis equal
title('3-D recontruction of the House along with two camera centers, in magenta and cyan');
disp('Code paused, press escape to close all the open figures');
pause;
close all;
% Z1 = P1*X;
% Z2 = P2*X;

