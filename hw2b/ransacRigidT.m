function [bestT, bestInliers] = ransacRigidT(wp1,wp2,xy1,xy2,sp1,sp2,K,nIter,tol)
P1 = K*[1 0 0 0; 0 1 0 0; 0 0 1 0];    
bestInliers = 0;
bestP = [];
bestR = [];
bestT = [];
bestError = 0;
bestFeatures = [];
bestSP = [];
bestWP = [];
bestXY = [];
for i=1:nIter

    idx = randperm(size(wp1,2),3);
    thisInliers = 0;
    thisError = 0;
    [T,Eps] = estimateRigidTransform(wp1(1:3,idx),wp2(1:3,idx));
    P = K*T(1:3,:);
    inFeatures = [];
    inSP = [];
    inWP = [];
    inXY = [];
    inRatioX = [];
    for j=1:size(wp2,2)
%         
%        guess = P*wp2(:,j);
%        guess = guess/guess(3);
%        guessError = sqrt( (guess(1) - xy2(1,j))^2 + (guess(2) - xy2(2,j))^2 );
       
       guess = T*wp2(:,j);
       guess = guess/guess(4);
       guessError = sqrt( (guess(1) - wp1(1,j))^2 + (guess(2) - wp1(2,j))^2 + (guess(3) - wp1(3,j))^2 );
       %pause(.1);
       if guessError < tol
           thisInliers = thisInliers + 1;
           thisError = thisError + guessError;
           %inFeatures(end+1) = features1(j);
           inWP(:,end+1) = wp1(:,j);
           
           inXY(:,end+1) = xy2(:,j) - xy1(:,j);
           inSP(:,end+1) = sp1(:,j);
           inRatioX(end+1) = (xy2(1,j) - xy1(1,j))/sp1(1,j);
       end
    end
    distanceVal = thisError / thisInliers;
    if (thisInliers > bestInliers || (thisInliers == bestInliers && bestError > thisError))
        bestInliers = thisInliers;
        bestT = T/T(4,4);
        bestError = thisError;
        bestFeatures = inFeatures;
        bestSP = inSP;
        bestWP = inWP;
        bestXY = inXY;
        bestRatio = inRatioX;
       
    end
end

%update translation for the ratio
t = bestT(1:3,4)
if ~sum(isinf(mean(bestRatio))) && t(1)~=0
    mean(bestRatio)
    
    t = t*((162.1*mean(bestRatio))/t(1));
else
    t = t*0;
end
bestT(1:3,4) = t



% figure;
% hold on;
P = K*T(1:3,:);
for i=1:size(xy1,2)
    rp = P*wp2(:,i);
    rp = rp/rp(3);
    
%     plot(xy2(1,i),xy2(2,i),'r*');
    %text(double(xy2(1,i)),double(xy2(2,i)),num2str(i));
    
%     plot(rp(1),rp(2),'ob');
end

% hold off;
fprintf('best inliers = %d\n',bestInliers);

end