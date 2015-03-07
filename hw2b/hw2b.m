 close all;
% imLeft = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/left000.jpg')));
% imRight = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/right000.jpg')));
% size(imLeft)
% leftFeatures = detectSURFFeatures(imLeft);
% rightFeatures = detectSURFFeatures(imRight);
% load('cameraparams');
% imLeft2 = undistortImage(imLeft,cameraParams);
% imRight2 = undistortImage(imRight,cameraParams);
% 
% [features1, valid_points1] = extractFeatures(imLeft2, leftFeatures);
% [features2, valid_points2] = extractFeatures(imRight2, rightFeatures);
% 
% [indexPairs] = matchFeatures(features1,features2,'MaxRatio',.4)
% 
% matchedPoints1 = valid_points1(indexPairs(:, 1), :);
% matchedPoints2 = valid_points2(indexPairs(:, 2), :);
%     
% 
% S = size(matchedPoints1,1);
% pts1 = [];
% pts2 = [];
% temp1 = [];
% temp2 = [];
% 
% for i = 1:S
%    temp1 = [round(matchedPoints1(i).Location)]';
%    pts1 = [pts1 temp1];
%    temp2 = [round(matchedPoints2(i).Location)]';
%    pts2 = [pts2 temp2];
% end
% 
% pts1(3,:) = 1;
% pts2(3,:) = 1;
% 
% figure; showMatchedFeatures(imLeft, imRight, matchedPoints1, matchedPoints2);
% figure;
% imshow(imLeft2);
% hold on;
% plot(pts1(1,1:7),pts1(2,1:7),'.r');
% hold off;
% 
% figure;
% imshow(imRight2);
% hold on;
% plot(pts2(1,:),pts2(2,:),'.b');
% hold off;
% 
% pause;
% %close all;
% F = estimateFundamentalMatrix(matchedPoints1,matchedPoints2);
% 
% K(1,1)= 164.255034407511;
% K(1,2)= 0.0;
% K(1,3)= 214.523999214172;
% K(2,1)= 0.0;
% K(2,2)= 164.255034407511;
% K(2,3)= 119.433252334595;
% K(3,1)= 0.0;
% K(3,2)= 0.0;
% K(3,3)= 1.0;
% % K = cameraParams.IntrinsicMatrix'
% E = K'*F*K
% [U S V] = svd(E);
% S
% W = [ 0 -1 0; 1 0 0; 0 0 1];
% 
% tx = V'*W*S*V
% t = [tx(3,2);tx(1,3);tx(2,1)] %hat op
% R = U*inv(W)*V
% 
% tx2 = V'*inv(W)*S*V
% t2 = [tx2(3,2);tx2(1,3);tx2(2,1)] %hat op
% R2 = U*W*V
% 
% %P
% 
% 
% R =[1 0 0 0; 0 1 0 0; 0 0 1 0]
% P1 = K*R
% R2 = [0.9925    0.1210    0.0168 .1621;
%    -0.1221    0.9877    0.0974 0;
%     0.0048    0.0987   -0.9951 0]
% 
%  R2 =[1 0 0 .1621; 0 1 0 0; 0 0 1 1]
% P2 = K*R2
% % plot3d = [];
% % for i=1:size(pts1,2)
% %     pinv(P1)*pts1(:,i)
% %      plot3d = [plot3d h];
% % end
% % hold on;
% % figure;
% % plot3(plot3d(1,:),plot3d(2,:),plot3d(3,:),'or');
% % hold off;
% 
% worldPoints = triangulate(pts1,pts2,P1,P2);

K(1,1)= 164.255034407511;
K(1,2)= 0.0;
K(1,3)= 214.523999214172;
K(2,1)= 0.0;
K(2,2)= 164.255034407511;
K(2,3)= 119.433252334595;
K(3,1)= 0.0;
K(3,2)= 0.0;
K(3,3)= 1.0;
im1l = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/left000.jpg')));
im1r = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/right000.jpg')));
im2l = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/left001.jpg')));

[R,t] = incrementalRT(im1l,im1r,im2l,K);

%H = [h(1) h(2) h(3); h(4) h(5) h(6); h(7) h(8) h(9)];
%pts1(:,1)*inv(H)

