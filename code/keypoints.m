%finding keypoints pixels
function [keypoint, coordinates] = keypoints(im, neighbourhood_size, r, c)
	%% im is the image where neighbourhood pixels has to be found
	%% neighbourhood_size is the matrix dimension of the neighbourhood pixels
	%% r and c are the coordinates of the local features /keypoints found earlier using harris/blob detector
	warning('off','all')
	K=0;
	feature_count=size(r,1); %count the number of the total feature points detected by the harris detector
	local_features = zeros(feature_count, neighbourhood_size,neighbourhood_size); %create matrix for storing the pixel neighbourhood of each each feature point, here 8 neighbours are detected plus original feature pixel
	[h, w] = size(im);
	R=[];
	C=[];
	% size(local_features)
	div = (neighbourhood_size-1)/2;
	for k =1:feature_count
		i = r(k,1);
		j = c(k,1);
		if (i-div>0 && j-div > 0 && i+div < h && j+div < w ) %% bypassing feature points near the vicinity of the borders of the picture
			K=K+1;
			local_features(K, :,:) = im(i-div:i+div,j-div:j+div);
			R(K) = i;
			C(K) = j;
		end
	end
	local_features =  local_features(1:K,:,:); %% removing redundant zeros as K may be less than the total featur4e points in actual
	%reshaping the local_features matrix into 1-D vector, flattening
	keypoint = reshape(local_features, [], neighbourhood_size*neighbourhood_size);
	%standardizing the features
	for i=1:K
		keypoint(i,:) = (keypoint(i,:) - mean(keypoint(i,:)))/std(keypoint(i,:));
	end
	R=R';
	C=C';
	coordinates = zeros(K, 2);
	size(coordinates);
	coordinates(:,1) = C(:,1);
	coordinates(:,2) = R(:,1);