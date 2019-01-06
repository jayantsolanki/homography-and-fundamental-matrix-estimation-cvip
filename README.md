***
# Homography-and-fundamental-matrix-estimation-cvip

## Project Summary
***
This project demonstrates implementation and results of the application of the Homography matrix in stitching pairs of images taken from same camera at same position but at different rotation along the camera axis. Supports multiple image stitchings.
This project demonstrates implementation and results of the application of the Homography matrix in stitching pairs of images taken from same camera at same position but at different rotation along the camera axis. Accompanying report talks about the estimation of 3-D coordinates from the 2-D coordinates of an object where stereo images have been taken of it by two camera using Epipolar Geometry and Fundamental Matrix. In the first part, using pairs of two consecutively taken images of same object, we estimate the homography matrix using the keypoints features detected on both the images and applying RANSAC algorithm to get the inliers. The Homography matrix is
then used for stitching both image to generate Panorama.

In the second part of the project, we generate the fundamental matrices of a pair of images using the groundtruth points and inliers generated during the first part. We use normalised and unnormalised approach to generate the matrix. We also compare the result of the both approach. Later on we also approximate the 3-D coordinates of the object in the pairs of image using Triangulation method. All the coding has been done in the MATLAB environment and proper references have been highlighted in the report.

## Results
***
### Example 1, stitching  image pair
#### Detecting corners (keypoint features) using Harris blob detector

<table border="0">
 <tr>
    <td align="center"><b style="font-size:30px">Image 1</b></td>
    <td align="center"><b style="font-size:30px">Image 2</b></td>
 </tr>
 <tr>
    <td> <img src="https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/harris1.jpg"></td>
    <td><img src="https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/harris2.jpg"></td>
 </tr>
</table>

#### plotting putative matches
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/putative.jpg)

### Matching keypoint features, finding inliers using RANSAC algorithm
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/inliers.jpg)

#### Using Homography matrix to transform the right image
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/transimage.jpg)

#### Finally the stitched images
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/stitched.jpg)

### Example 2, stitching  multiple images
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/ledge.jpg)
***

### Example 3, Estimating 3-D coordinates of an object in an image
#### Step 1
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/GF1.jpg)
#### Step 2
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/GF2.jpg)
#### Step 3
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/put1F.jpg)
#### Step 4
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/put2F.jpg)
#### Step 5, plotting the coordinates, Camera positions in magenta and cyan
![alt text](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/raw/master/Report/3D.jpg)


## Report
***
Report can be found under [Report](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/blob/master/Report/50246821.pdf.pdf) link

## Folder Tree
***
* [**Report**](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/tree/master/Report) contains the report
* [**Code**](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/tree/master/code)  contains the implementation matlab code
* [**Data**](https://github.com/jayantsolanki/homography-and-fundamental-matrix-estimation-cvip/tree/master/data) contains images to be stiched

## Datasheet
***
1. Datasheet: https://goo.gl/knJzpc

## Software/Hardware
***
1. MATLAB R2017a on personal system
2. Intel i3, 3GB Ram, Sublime Text 3 IDE

## References
***
1. MATLAB Documentation
2. Hw3.pdf
3. Lecture slides
4. Brigham University Robotic Lab
5. Sample Harris detector code
