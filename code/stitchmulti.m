%simple script to stitch multiimages
% uttower
im1=imread('..\data\part1\uttower\left.JPG');
im2=imread('..\data\part1\uttower\right.JPG');
% hill
% im1=imread('..\data\part1\hill\1.JPG');
% im2=imread('..\data\part1\hill\2.JPG');
% im3=imread('..\data\part1\hill\3.JPG');
% pier
% im1=imread('..\data\part1\pier\1.JPG');
% im2=imread('..\data\part1\pier\2.JPG');
% im3=imread('..\data\part1\pier\3.JPG');
% ledge
% im1=imread('..\data\part1\ledge\1.JPG');
% im2=imread('..\data\part1\ledge\2.JPG');
% im3=imread('..\data\part1\ledge\3.JPG');
%set last param to 1 for no image
result = stitch(im1, im2, 1, 0.05, 1);
% imshow(result);
% disp('Stitching the third image');
% result = stitch(result,im3, 1, 0.005, 0);
figure; clf; hold on;
imshow(result);
title('Stitched images');
disp('Execution paused, press escape to close all the exisiting image figure and continue execution')
pause;
close all;%closes all the opened figures