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
    % XiMean = sum(matches(:,1))/length(matches);
    % YiMean = sum(matches(:,2))/length(matches);
    % xi_Mean = sum(matches(:,3))/length(matches);
    % yi_Mean = sum(matches(:,4))/length(matches);
    % DXY = sqrt(sum((matches(:,1)-XiMean).^2+(matches(:,2)-YiMean).^2)/2*(length(matches)));
    % Dxy__ = sqrt(sum((matches(:,3)-xi_Mean).^2+(matches(:,4)-yi_Mean).^2)/2*(length(matches)));
 %    % % DXY = std(matches(:,1:2))
 %    % % Dxy__ = std(matches(:,3:4));
 %    % % creating tranforomation matrices for each coordinates set
 %    TXY = [1/DXY, 0, -1*XiMean/DXY; 0, 1/DXY, -1*YiMean/DXY;	0, 0, 1]%adding 2, for maintaining 2 pixels distance
 %    Txy__ = [1/Dxy__, 0, -1*xi_Mean/Dxy__; 0, 1/Dxy__, -1*yi_Mean/Dxy__;	0, 0, 1]%adding 2, for maintaining 2 pixels distance
 	% J = var(matches)
 	% matches = bsxfun(@minus,matches,mean(matches))
 	% matches = bsxfun(@multiply,matches,J)
	% matches(:,1) = (matches(:,1) - mean(matches(:,1)))/2*std(matches(:,1));
	% matches(:,2) = (matches(:,2) - mean(matches(:,2)))/2*std(matches(:,2));
	% matches(:,3) = (matches(:,3) - mean(matches(:,3)))/2*std(matches(:,3));
	% matches(:,4) = (matches(:,4) - mean(matches(:,4)))/2*std(matches(:,4));
	% std(matches(:,1))
	% std(matches(:,2))
	% std(matches(:,3))
	% std(matches(:,4))
	Xi = matches(:,1);
    Yi = matches(:,2);
    xi_ = matches(:, 3);
    yi_ = matches(:, 4);
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
    % F = TXY*F*Txy__'
    F
    % F = [-0.0000 -0.0001 0.0177; 0.0001 -0.0000 -0.0181; -0.0117 0.0234 -0.9993]

    % F = inv(Txy__')*F*inv(TXY);
    % F;

% 



end