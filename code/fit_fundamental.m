%fit_funcdamental.m
%this function claculates the Fundamental Matrix using 8-points alogrithm, either normalised or unnormalised 
function [F] = fit_fundamental(matches)
	% Arguments:   
	%            matches      - groundtruths cooridnates or the inliers sent by the ransac
	%
	% Returns:
	%            F    			   - Fundamental Matrix

	% F = zeros(3,3);
	%performing the transformation of the F, normalisation step
	flag = 1;%set this to 0 for performing Fundamental matrix calculation on unnormalised coordinates
	if flag == 1
		XiMean = sum(matches(:,1))/length(matches);
	    YiMean = sum(matches(:,2))/length(matches);
	    xi_Mean = sum(matches(:,3))/length(matches);
	    yi_Mean = sum(matches(:,4))/length(matches);
	    DXY = sum(sqrt(((matches(:,1)-XiMean).^2+(matches(:,2)-YiMean).^2)))/2*length(matches);%calculating the combined standard deviation
	    Dxy__ = sum(sqrt(((matches(:,3)-xi_Mean).^2+(matches(:,4)-yi_Mean).^2)))/2*length(matches);
	end
 %    Scalef = @(s)([ s 0 0; 0 s 0; 0 0 1]);
	% % Same for translation
	% Transf = @(tx,ty)([1 0 tx; 0 1 ty; 0 0 1]);
	% AXY = Transf(XiMean, YiMean)* Scalef(DXY);
	% Axy = Transf(xi_Mean, yi_Mean)* Scalef(Dxy__);
	% AXY = AXY(1:2, :)';
	% Axy = Axy(1:2, :)';

	% TXY = [ s 0 0; 0 s 0; 0 0 1]*[1 0 tx; 0 1 ty; 0 0 1]
	if flag == 1
		TXY = [1/DXY, 0, -1*XiMean/DXY; 0, 1/DXY, -1*YiMean/DXY;	0, 0, 1];%adding 2, for maintaining 2 pixels distance
	    Txy__ = [1/Dxy__, 0, -1*xi_Mean/Dxy__; 0, 1/Dxy__, -1*yi_Mean/Dxy__;	0, 0, 1];%adding 2, for maintaining 2 pixels distance
		XY = [matches(:,1:2)';ones(1,length(matches))]; %adding the homogeneous column
		xy__ = [matches(:,3:4)';ones(1,length(matches))]; %adding the homogeneous column
		XY_trans = TXY*XY;
		xy__trans = Txy__*xy__;
		XY_trans = XY_trans';
		xy__trans = xy__trans';
		tempXY = XY_trans(:,1:2);
		tempxy__ = xy__trans(:,1:2);
	    tempXY(:,1)=tempXY(:,1)./XY_trans(:,3);%normalising the row with the homogneous column, w
	    tempXY(:,2) = tempXY(:,2)./XY_trans(:,3);%normalising the column with the homogneous column, w
	    tempxy__(:,1)=tempxy__(:,1)./xy__trans(:,3);%normalising the row with the homogneous column, w
	    tempxy__(:,2) = tempxy__(:,2)./xy__trans(:,3);%normalising the column with the homogneous column, w
	    matches(:,1:2) = tempXY;
    	matches(:,3:4) = tempxy__;
	end
	Xi = matches(:,1);
    Yi = matches(:,2);
    xi_ = matches(:,3);
    yi_ = matches(:,4);
	A = [];
    for i = 1:length(matches) %replace this code later on, N should be atleast 8
        A = cat(1, A, cat(2, xi_(i)*Xi(i), xi_(i)*Yi(i), xi_(i), yi_(i)*Xi(i), yi_(i)*Yi(i), yi_(i), Xi(i), Yi(i), 1));
    end
    [U,D,V] = svd(A);
    F = reshape(V(:,9), 3, 3)';
    [FU, FD, FV] = svd(F);
    [r,c] = min(diag(FD));
    FD(c,c) = 0; %enforcing singularity
    F = FU * FD * FV';%calculated using unnormalised coordinates
    if flag ==1
	    F = Txy__'*F*TXY
	    F = F/F(3,3);
	end
    % F = [-0.0000 -0.0001 0.0177; 0.0001 -0.0000 -0.0181; -0.0117 0.0234 -0.9993]

    % F = inv(Txy__')*F*inv(TXY);
    % F;

% 



end