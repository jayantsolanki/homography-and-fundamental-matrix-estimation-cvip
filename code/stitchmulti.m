%simple script to stitch multiimages
im1=imread('..\data\part1\pier\1.JPG');
im2=imread('..\data\part1\pier\2.JPG');
im3=imread('..\data\part1\pier\3.JPG');
result = stitch(im1, im2, 0);
% imshow(result);
result2 = stitch(result,im3, 0);
imshow(result2);