function [R,t] = incrementalRT(im1l,im1r,im2l,K)
Features1Left = detectSURFFeatures(im1l);
Features1Right = detectSURFFeatures(im1r);
Features2Left = detectSURFFeatures(im2l);

[features1l, valid_points1l] = extractFeatures(im1l, Features1Left);
[features1r, valid_points1r] = extractFeatures(im1r, Features1Right);

[indexPairs] = matchFeatures(features1l,features1r,'MaxRatio',.4)

matchedPoints1l = valid_points1l(indexPairs(:, 1), :);
matchedPoints1r = valid_points1r(indexPairs(:, 2), :);
% matchedFeatures1l = features1l(indexPairs(:,1),:);

pts1 = [];
pts2 = [];
%pts1index = [];

for i = 1:size(matchedPoints1l,1)
   temp1 = [round(matchedPoints1l(i).Location) 1]';
   pts1 = [pts1 temp1];
   %pts1index = [pts1index indexPairs(i,1)];
   temp2 = [round(matchedPoints1r(i).Location) 1]';
   pts2 = [pts2 temp2];
   
end

R =[1 0 0 0; 0 1 0 0; 0 0 1 0]
P1 = K*R

R2 =[1 0 0 .1621; 0 1 0 0; 0 0 1 1]
P2 = K*R2
worldPoints = triangulate(pts1,pts2,P1,P2);




[features2l, valid_points2l] = extractFeatures(im2l, Features2Left);

[indexPairs2] = matchFeatures(features1l,features2l,'MaxRatio',.4);
indicies = [];
savedWorldPoints = [];
for n=1:size(indexPairs2,1)
    if (sum(indexPairs(:,1)==indexPairs2(n,1)))
        indicies = [indicies n];
        %save worldpoint
        savedWorldPoints= [savedWorldPoints worldPoints(:,find(indexPairs(:,1)==indexPairs2(n,1)))];
    end
end

% matchedPoints1l = valid_points1l(indexPairs(:, 1), :);

 matchedPoints1 = valid_points1l(indexPairs2(indicies, 1));
 matchedPoints2 = valid_points2l(indexPairs2(indicies, 2));

% points1 = [];
% points2 = [];
% for i = 1:size(matchedPoints1,1)
%    temp1 = [round(matchedPoints1(i).Location) 1]';
%    if(points1(1) == temp1(1) && points1(2) == temp1(2))
%        
%        points1 = [points1 temp1];
%        temp2 = [round(matchedPoints2(i).Location) 1]';
%        points2 = [points2 temp2];
%    end
% end

figure; showMatchedFeatures(im1l, im2l, matchedPoints1, matchedPoints2);

[bestR bestT] = ransacFund(matchedPoints1,matchedPoints2,savedWorldPoints,K,1000,1);

end