function [bestR bestT] = ransacFund(matchedPoints1,matchedPoints2,worldPoints,K,nIter,tol)
P1 = K*[1 0 0 0; 0 1 0 0; 0 0 1 0];    
bestInliers = 0;
bestP = [];
bestR = [];
bestT = [];

for i=1:nIter

    idx = randperm(size(matchedPoints1,1),16)
    
    match1 = matchedPoints1(idx);
    match2 = matchedPoints2(idx);

    F = estimateFundamentalMatrix(match1,match2);
    E = K'*F*K;
    [U S V] = svd(E);
    
    W = [ 0 -1 0; 1 0 0; 0 0 1];

    tx = V'*W*S*V;
    t = [tx(3,2);tx(1,3);tx(2,1)]; %hat op
    R = U*inv(W)*V;

    tx2 = V'*inv(W)*S*V;
    t2 = [tx2(3,2);tx2(1,3);tx2(2,1)]; %hat op
    R2 = U*W*V;
    
    t = t/t(3);
    t2 = t2/t2(3);
    %Create the 4 possible P matricies
    P21 = K*[R(1,1) R(1,2) R(1,3) t(1); R(2,1) R(2,2) R(2,3) t(2); R(3,1) R(3,2) R(3,3) 1];
    P22 = K*[R(1,1) R(1,2) R(1,3) t2(1); R(2,1) R(2,2) R(2,3) t2(2); R(3,1) R(3,2) R(3,3) 1];
    P23 = K*[R2(1,1) R2(1,2) R2(1,3) t(1); R2(2,1) R2(2,2) R2(2,3) t(2); R2(3,1) R2(3,2) R2(3,3) 1];
    P24 = K*[R2(1,1) R2(1,2) R2(1,3) t2(1); R2(2,1) R2(2,2) R2(2,3) t2(2); R2(3,1) R2(3,2) R2(3,3) 1];

    %See which has the lowest error
    
        temp = [round(matchedPoints1(idx(1)).Location)]';
        
        guess21 = P21*worldPoints(:,idx(1));
        guess21 = guess21/guess21(3);
        error21 = sqrt((temp(1) - guess21(1))^2 + (temp(2) - guess21(2))^2);
        
        guess22 = P22*worldPoints(:,idx(1));
        guess22 = guess22/guess22(3);
        error22 = sqrt((temp(1) - guess22(1))^2 + (temp(2) - guess22(2))^2);
        
        guess23 = P23*worldPoints(:,idx(1));
        guess23 = guess23/guess23(3);
        error23 = sqrt((temp(1) - guess23(1))^2 + (temp(2) - guess23(2))^2);
        
        guess24 = P24*worldPoints(:,idx(1));
        guess24 = guess24/guess24(3);
        error24 = sqrt((temp(1) - guess24(1))^2 + (temp(2) - guess24(2))^2);
        
   
    %Pick the P with the smallest error
    errors = [error21 error22 error23 error24];
    [~,n] = min(errors);
    if n == 1
        P = P21;
        R = R;
        T = t;
    elseif n == 2
        P = P22;
        R = R;
        T = t2;
    elseif n == 3
        P = P23;
        R = R2;
        T = t;
    elseif n == 4
        P = P24;
        R = R2;
        T = t2;
    end
    
    thisInliers = 0;
    for j=1:size(worldPoints,2)
        point = [round(matchedPoints1(idx(1)).Location)]'
        worldPoints(:,j)
        guess = P*worldPoints(:,j);
        guess = guess/guess(3)
        
        guessError = sqrt( (guess(1) - point(1))^2 + (guess(2) - point(2))^2 )
        %pause(01);
        if guessError < tol
            thisInliers = thisInliers + 1;
        end
        
    end
    if thisInliers > bestInliers
        bestInliers = thisInliers
        bestP = P;
        bestR = R;
        bestT = T;
    end
    
end



end