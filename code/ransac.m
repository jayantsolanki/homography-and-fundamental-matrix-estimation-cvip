%ransac.m
function [H, inliers, residual_error] = ransac(INPUTS, OUTPUTS, iterations)
% Arguments:   
%            INPUTS      - keypoint features corrdinates of the first image
%            OUTPUTS     - keypoint features corrdinates of the seond image
%            iterations  - number of times ransac has to run
%
% Returns:
%            H    			   - optimum Homography matrix calculated
%            inliers    	   - returns the inliers indices found in the keypoint features
%            residual_error    - average error found in the inliers
	warning('off','all')
	optimum_inliers_count = 0;
	error_threshold = 25;
	Matches = size(INPUTS,1);%get the totals match size
	for i =1:iterations

		index = randperm(Matches,4); %randomly taking 4 pairs of matches
		coordinates1 = INPUTS(index,:);
		coordinates2 = OUTPUTS(index,:);
		% coordinates1 = [141, 131;480, 159 ;493, 630;64, 601];
		% coordinates2 = [318, 256;534, 372;316, 670;73, 473];
		% A = [coordinates1(1,1), coordinates1(1,2), 1, 0, 0, 0, -1*coordinates1(1,1)*coordinates2(1,1), -1*coordinates1(1,2)*coordinates2(1,1); coordinates1(2,1), coordinates1(2,2), 1, 0, 0, 0, -1*coordinates1(2,1)*coordinates2(2,1), -1*coordinates1(2,2)*coordinates2(2,1); coordinates1(3,1), coordinates1(3,2), 1, 0, 0, 0, -1*coordinates1(3,1)*coordinates2(3,1), -1*coordinates1(3,2)*coordinates2(3,1); coordinates1(4,1), coordinates1(4,2), 1, 0, 0, 0, -1*coordinates1(4,1)*coordinates2(4,1), -1*coordinates1(4,2)*coordinates2(4,1); 0, 0, 0, coordinates1(1,1), coordinates1(1,2), 1, -1*coordinates1(1,1)*coordinates2(1,2), -1*coordinates1(1,2)*coordinates2(1,2); 0, 0, 0, coordinates1(2,1), coordinates1(2,2), 1, -1*coordinates1(2,1)*coordinates2(2,2), -1*coordinates1(2,2)*coordinates2(2,2); 0, 0, 0, coordinates1(3,1), coordinates1(3,2), 1, -1*coordinates1(1,1)*coordinates2(3,2), -1*coordinates1(3,2)*coordinates2(3,2); 0, 0, 0, coordinates1(4,1), coordinates1(4,2), 1, -1*coordinates1(4,1)*coordinates2(4,2), -1*coordinates1(4,2)*coordinates2(4,2);
		%  ];
		A = [coordinates1(1,1), coordinates1(1,2), 1, 0, 0, 0, -1*coordinates1(1,1)*coordinates2(1,1), -1*coordinates1(1,2)*coordinates2(1,1);  0, 0, 0, coordinates1(1,1), coordinates1(1,2), 1, -1*coordinates1(1,1)*coordinates2(1,2), -1*coordinates1(1,2)*coordinates2(1,2); coordinates1(2,1), coordinates1(2,2), 1, 0, 0, 0, -1*coordinates1(2,1)*coordinates2(2,1), -1*coordinates1(2,2)*coordinates2(2,1);  0, 0, 0, coordinates1(2,1), coordinates1(2,2), 1, -1*coordinates1(2,1)*coordinates2(2,2), -1*coordinates1(2,2)*coordinates2(2,2); coordinates1(3,1), coordinates1(3,2), 1, 0, 0, 0, -1*coordinates1(3,1)*coordinates2(3,1), -1*coordinates1(3,2)*coordinates2(3,1);  0, 0, 0, coordinates1(3,1), coordinates1(3,2), 1, -1*coordinates1(3,1)*coordinates2(3,2), -1*coordinates1(3,2)*coordinates2(3,2); coordinates1(4,1), coordinates1(4,2), 1, 0, 0, 0, -1*coordinates1(4,1)*coordinates2(4,1), -1*coordinates1(4,2)*coordinates2(4,1);  0, 0, 0, coordinates1(4,1), coordinates1(4,2), 1, -1*coordinates1(4,1)*coordinates2(4,2), -1*coordinates1(4,2)*coordinates2(4,2);
		 ];
		 % coordinates2
		b = reshape(coordinates2', 8, []); %vectorising the output coordinates
		H = A\b;
		% [U, S, V] = svd(A);
		% H = V(:,end);
		H(9,1) = 1;
		H = reshape(H, 3,3, [])';
		% Hc = inv(H);
		% H = Hc/Hc(3,3);
		% % size(H)
		% A = [];
	 %    for i = 1:4 %replace this code later on
	 %        Xi = [coordinates1(i,:)'; 1];
	 %        xi_ = coordinates2(i, 1);
	 %        yi_ = coordinates2(i, 2);
	 %        zs = zeros(3, 1);
	 %        A = cat(1, A, cat(2, zs', Xi', -yi_*Xi'));
	 %        A = cat(1, A, cat(2, Xi', zs', -xi_*Xi'));
	 %    end

	 %    [U, S, V] = svd(A);
	 %    H = V(:,end);

	 %    H = reshape(H, [3 3])'
		% coordinates1 = coordinates1'
		% coordinates3 = coordinates2'

		inputs = [INPUTS';ones(1,Matches)]; %adding the homogeneous column
		% coordinates2 = [coordinates2';ones(1,size(coordinates2, 1))]
		inputs_trans = H*inputs;
		inputs_trans = inputs_trans';
		tempInputs = inputs_trans(:,1:2);
	    tempInputs(:,1)=tempInputs(:,1)./inputs_trans(:,3);%normalising the column with the homogneous column, w
	    tempInputs(:,2) = tempInputs(:,2)./inputs_trans(:,3);%normalising the column with the homogneous column, w
	    inputs_trans = tempInputs;
	    error = sum((inputs_trans-OUTPUTS).^2,2);
	    inliers_temp = find(error<error_threshold);%getting the indices of those coordinates which have low error difference with the acgual output
	    inliers_temp_count = length(inliers_temp);
	    if (inliers_temp_count > optimum_inliers_count)
	    	optimum_H=H;
	    	optimum_inliers = inliers_temp;
	    	optimum_inliers_count = inliers_temp_count;
	    	avg_residual_error = mean(error(optimum_inliers));
	    end
	end
	H = optimum_H;
	inliers = optimum_inliers;
	optimum_inliers_count;
	residual_error = avg_residual_error;
	% Matches;
	coordinates1 = INPUTS(inliers,:);
	coordinates2 = OUTPUTS(inliers,:);
	% A = [coordinates1(1,1), coordinates1(1,2), 1, 0, 0, 0, -1*coordinates1(1,1)*coordinates2(1,1), -1*coordinates1(1,2)*coordinates2(1,1);  0, 0, 0, coordinates1(1,1), coordinates1(1,2), 1, -1*coordinates1(1,1)*coordinates2(1,2), -1*coordinates1(1,2)*coordinates2(1,2); coordinates1(2,1), coordinates1(2,2), 1, 0, 0, 0, -1*coordinates1(2,1)*coordinates2(2,1), -1*coordinates1(2,2)*coordinates2(2,1);  0, 0, 0, coordinates1(2,1), coordinates1(2,2), 1, -1*coordinates1(2,1)*coordinates2(2,2), -1*coordinates1(2,2)*coordinates2(2,2); coordinates1(3,1), coordinates1(3,2), 1, 0, 0, 0, -1*coordinates1(3,1)*coordinates2(3,1), -1*coordinates1(3,2)*coordinates2(3,1);  0, 0, 0, coordinates1(3,1), coordinates1(3,2), 1, -1*coordinates1(3,1)*coordinates2(3,2), -1*coordinates1(3,2)*coordinates2(3,2); coordinates1(4,1), coordinates1(4,2), 1, 0, 0, 0, -1*coordinates1(4,1)*coordinates2(4,1), -1*coordinates1(4,2)*coordinates2(4,1);  0, 0, 0, coordinates1(4,1), coordinates1(4,2), 1, -1*coordinates1(4,1)*coordinates2(4,2), -1*coordinates1(4,2)*coordinates2(4,2);
	% 	 ]
	%recalculating the new Homogrpahy matrix based upon inliers coordinates
	A = [];
    for i = 1:optimum_inliers_count %replace this code later on
        Xi = coordinates1(i,:);
        xi_ = coordinates2(i, 1);
        yi_ = coordinates2(i, 2);
        zs = zeros(3, 1);
        A = cat(1, A, cat(2, Xi, 1, zs', -Xi(1)*xi_, -Xi(2)*xi_));
        A = cat(1, A, cat(2, zs', Xi, 1, -Xi(1)*yi_, -Xi(2)*yi_));
    end
	b = reshape(coordinates2', optimum_inliers_count*2, []); %vectorising the output coordinates
		H = A\b;
		H(9,1) = 1;
		H = reshape(H, 3,3, [])';