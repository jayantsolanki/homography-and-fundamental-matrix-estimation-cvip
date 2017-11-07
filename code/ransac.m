function [H, inliers, residual_error] = ransac(INPUTS, OUTPUTS, iterations, im1, im2)
	%% 
	%% 
	%% 
	optimum_inliers_count = 0;
	Matches = size(INPUTS,1);%get the totals match size
	for i =1:iterations

		index = randperm(Matches,4) %randomly taking 4 pairs of matches
		coordinates1 = INPUTS(index,:);
		coordinates2 = OUTPUTS(index,:);
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
		% size(H)
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
		inputs = [INPUTS';ones(1,Matches)]; %adding the homoneous column
		% coordinates2 = [coordinates2';ones(1,size(coordinates2, 1))]
		inputs_trans = H*inputs;
		inputs_trans = inputs_trans';
		tempInputs = inputs_trans(:,1:2);
	    tempInputs(:,1)=tempInputs(:,1)./inputs_trans(:,3);%normalising the column with the homogneous column, w
	    tempInputs(:,2) = tempInputs(:,2)./inputs_trans(:,3);%normalising the column with the homogneous column, w
	    inputs_trans = tempInputs;
	    OUTPUTS;
	    error = sum((inputs_trans-OUTPUTS).^2,2);
	    inliers_temp = find(error<0.3)%getting the indices of those coordinates which have low error difference with the acgual output
	    inliers_temp_count = length(inliers_temp);
	    if (inliers_temp_count > optimum_inliers_count)
	    	optimum_H=H;
	    	optimum_inliers = inliers_temp;
	    	optimum_inliers_count = inliers_temp_count;
	    	avg_residual_error = mean(error(optimum_inliers));
	    end
	end
	% tform = maketform('projective',H');
	% homoTrans = maketform('projective', H)
	% img1Trans = imtransform(im1, tform, 'nearest');
	% figure, imshow(img1Trans);
	% pts3 = pts3(1:2,:)./repmat(pts3(3,:),2,1);
	% d = sum((coordinates2-pts3).^2,1)
	H = optimum_H
	inliers = optimum_inliers;
	optimum_inliers_count
	residual_error = avg_residual_error
	Matches