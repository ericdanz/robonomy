close all;
K(1,1)= 164.255034407511;
K(1,2)= 0.0;
K(1,3)= 214.523999214172;
K(2,1)= 0.0;
K(2,2)= 164.255034407511;
K(2,3)= 119.433252334595;
K(3,1)= 0.0;
K(3,2)= 0.0;
K(3,3)= 1.0;

% 
% im1 = im2double(rgb2gray(imread('/home/ed/Documents/robonomy/hw2b/sensor_data/left000.jpg')));
% im2 = im2double(rgb2gray(imread('/home/ed/Documents/robonomy/hw2b/sensor_data/right000.jpg')));
% 
% [worldPoints1,features1,xy1,sp1] = triangulateIm(im1,im2,K);
% 
% im1 = im2double(rgb2gray(imread('/home/ed/Documents/robonomy/hw2b/sensor_data/left001.jpg')));
% im2 = im2double(rgb2gray(imread('/home/ed/Documents/robonomy/hw2b/sensor_data/right001.jpg')));
% 
% [worldPoints2,features2,xy2,sp2] = triangulateIm(im1,im2,K);
% 
% [indexPairs] = matchFeatures(features1,features2,'MaxRatio',.4);
% 
% 
% wp1 = worldPoints1(:,indexPairs(:,1));
% wp2 = worldPoints2(:,indexPairs(:,2));
% [bestT bestI] = ransacRigidT(wp1,wp2,xy1(:,indexPairs(:,1)),xy2(:,indexPairs(:,2)),sp1,sp2,K,2000,40);
% THistory = struct('T',bestT);
% % matlabpool open 2
% 
% parfor i=1:120
%   
%     im1 = im2double(rgb2gray(imread(sprintf('/home/ed/Documents/robonomy/hw2b/sensor_data/left%03d.jpg',i*5-4))));
%     im2 = im2double(rgb2gray(imread(sprintf('/home/ed/Documents/robonomy/hw2b/sensor_data/right%03d.jpg',i*5-4))));
%     im11 = im1  
%     [worldPoints1,features1,xy1,sp1] = triangulateIm(im1,im2,K);
% 
%     im1 = im2double(rgb2gray(imread(sprintf('/home/ed/Documents/robonomy/hw2b/sensor_data/left%03d.jpg',i*5))));
%     im2 = im2double(rgb2gray(imread(sprintf('/home/ed/Documents/robonomy/hw2b/sensor_data/right%03d.jpg',i*5))));
% 
%     [worldPoints2,features2,xy2,sp2] = triangulateIm(im1,im2,K);
% 
%     [indexPairs] = matchFeatures(features1,features2,'MaxRatio',.4);
% 
%     wp1 = worldPoints1(:,indexPairs(:,1));
%     wp2 = worldPoints2(:,indexPairs(:,2));
% 
%    
%     [bestT bestI] = ransacRigidT(wp1,wp2,xy1(:,indexPairs(:,1)),xy2(:,indexPairs(:,2)),sp1,sp2,K,2000,40);
%     THistory(i+1) = struct('T',bestT);
%     fprintf('i = %d\n', i);
% end

currentH = eye(4);
points = [];
%figure; hold on;
for i=1:length(THistory)
    t = THistory(i).T(1:4,4);
    
    tDist = sqrt( t(1)^2 + t(2)^2 + t(3)^2)
    if tDist > 100
        t =  t / (tDist / 100);
        
        newT = [THistory(i).T(:,1:3) t]; 
        newT = eye(4);
    else
    newT = [THistory(i).T(:,1:3) t];    
    end
%     THistory(i).T
    %pause(01);
    %newT = [THistory(i).T(:,1:3) t];
    currentH = newT*currentH;
    points = [points currentH*[0;0;0;1]];
    %currP  = currentH*[0;0;0;1];
    %plot3(
end

points(1,:) = points(1,:)./points(4,:);
points(2,:) = points(2,:)./points(4,:);
points(3,:) = points(3,:)./points(4,:);

save('output.mat','THistory','points');

figure; hold on;
plot3(points(1,:),points(2,:),points(3,:),'b--o');
min = 100;
max = 200;
axis([-1*min,1*max,-1*min,1*max,-1*min,1*max]);
hold off;

% matlabpool close;


