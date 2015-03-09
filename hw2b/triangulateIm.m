function [worldPoints,matchedFeatures,pts1] = triangulateIm(im1,im2,K)
Features1 = detectSURFFeatures(im1);
Features2 = detectSURFFeatures(im2);

[features1, valid_points1] = extractFeatures(im1, Features1);
[features2, valid_points2] = extractFeatures(im2, Features2);

[indexPairs] = matchFeatures(features1,features2,'MaxRatio',.4);

matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);
matchedFeatures = features1(indexPairs(:,1),:);

pts1 = [];
pts2 = [];

for i = 1:size(matchedPoints1,1)
   temp1 = [round(matchedPoints1(i).Location) 1]';
   pts1 = [pts1 temp1];
   %pts1index = [pts1index indexPairs(i,1)];
   temp2 = [round(matchedPoints2(i).Location) 1]';
   pts2 = [pts2 temp2];
   
end

R =[1 0 0 0; 0 1 0 0; 0 0 1 0];
P1 = K*R;

R2 =[1 0 0 162.1; 0 1 0 0; 0 0 1 0];
P2 = K*R2;



%figure;
% hold on;
% 
% plot(pts1(1,:),pts1(2,:),'r*');
% %     ln = findobj('type','line');
% % 
% %     set(ln,'marker','.','markers',14,'markerfa','b');
% text(double(pts1(1,:)),double(pts1(2,:)),num2str(linspace(1,size(pts1,2),size(pts1,2))));
    
A = [];
worldPoints = [];
for i=1:size(pts1,2)
    A = [pts1(2,i)*P1(3,:)-P1(2,:); 
        P1(1,:)-pts1(1,i)*P1(3,:); 
        pts2(2,i)*P2(3,:)-P2(2,:); 
        P2(1,:)-pts2(1,i)*P2(3,:)];
%     for n=1:4
%         A(n,:) = A(n,:)/norm(A(n,:));
%     end
    [U S V] = svd(A);
      
    h = V(:,end);    
    rp = P1*h;
    worldPoints = [worldPoints h/h(4)];
    %plot(pts1(1,i),pts1(2,i),'r*');
    %text(double(pts1(1,i)),double(pts1(2,i)),num2str(i));
    
    %plot(rp(1)/rp(3),rp(2)/rp(3),'ob');
    
    
end
%hold off;

%hold on;
%figure ;plot3(worldPoints(1,:),worldPoints(2,:),worldPoints(3,:),'.g');
end
