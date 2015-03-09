function [bestT, bestInliers] = ransacRigidTweighted(wp1,wp2,xy1,xy2,K,nIter,tol)
P1 = K*[1 0 0 0; 0 1 0 0; 0 0 1 0];    
bestInliers = 0;
bestP = [];
bestR = [];
bestT = [];
bestError = 0;

for i=1:nIter

    idx = randperm(size(wp1,2),3);
    thisInliers = 0;
    thisError = 0;
    [T,Eps] = estimateRigidTransform(wp1(1:3,idx),wp2(1:3,idx));
    P = K*T(1:3,:);
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
       end
    end
    distanceVal = thisError / thisInliers;
    if (thisInliers > bestInliers || (thisInliers == bestInliers && bestError > thisError))
        bestInliers = thisInliers;
        bestT = T;
        bestError = thisError;
    end
end
% figure;
% hold on;
P = K*T(1:3,:);
for i=1:size(xy1,2)
    rp = P*wp2(:,i);
    rp = rp/rp(3);
    
%     plot(xy2(1,i),xy2(2,i),'r*');
    text(double(xy2(1,i)),double(xy2(2,i)),num2str(i));
    
%     plot(rp(1),rp(2),'ob');
end

% hold off;
fprintf('best inliers = %d\n',bestInliers);

end