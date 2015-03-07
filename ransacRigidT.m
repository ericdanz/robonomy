function [bestT, bestInliers] = ransacRigidT(wp1,wp2,xy1,xy2,K,nIter,tol)
P1 = K*[1 0 0 0; 0 1 0 0; 0 0 1 0];    
bestInliers = 0;
bestP = [];
bestR = [];
bestT = [];

for i=1:nIter

    idx = randperm(size(wp1,2),4);
    thisInliers = 0;
    [T,Eps] = estimateRigidTransform(wp1(1:3,idx),wp2(1:3,idx));
    P = K*T(1:3,:);
    for j=1:size(wp2,2)
       guess = P*wp2(:,j);
       guess = guess/guess(3);
       guessError = sqrt( (guess(1) - xy2(1,j))^2 + (guess(2) - xy2(2,j))^2 );
       if guessError < tol
           thisInliers = thisInliers + 1;
       end
    end
    if thisInliers > bestInliers
        bestInliers = thisInliers
        bestT = T;
    end
end
figure;
hold on;
P = K*T(1:3,:);
for i=1:size(xy1,2)
    rp = P*wp2(:,i);
    rp = rp/rp(3);
    
    plot(xy2(1,i),xy2(2,i),'r*');
    text(double(xy2(1,i)),double(xy2(2,i)),num2str(i));
    
    plot(rp(1),rp(2),'ob');
end

hold off;

end