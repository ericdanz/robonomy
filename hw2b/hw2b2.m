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


im1 = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/left000.jpg')));
im2 = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/right000.jpg')));

[worldPoints1,features1,xy1] = triangulateIm(im1,im2,K);

im1 = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/left001.jpg')));
im2 = im2double(rgb2gray(imread('/home/ed/Downloads/cmu_16662_p2/sensor_data/right001.jpg')));

[worldPoints2,features2,xy2] = triangulateIm(im1,im2,K);

[indexPairs] = matchFeatures(features1,features2,'MaxRatio',.4)


wp1 = worldPoints1(:,indexPairs(:,1));
wp2 = worldPoints2(:,indexPairs(:,2));
[bestT bestI] = ransacRigidT(wp1,wp2,xy1(:,indexPairs(:,1)),xy2(:,indexPairs(:,2)),K,2000,1);
THistory = struct('T',bestT);


parfor i=1:633
  
    im1 = im2double(rgb2gray(imread(sprintf('/home/ed/Downloads/cmu_16662_p2/sensor_data/left%03d.jpg',i))));
    im2 = im2double(rgb2gray(imread(sprintf('/home/ed/Downloads/cmu_16662_p2/sensor_data/right%03d.jpg',i))));

    [worldPoints1,features1,xy1] = triangulateIm(im1,im2,K);

    im1 = im2double(rgb2gray(imread(sprintf('/home/ed/Downloads/cmu_16662_p2/sensor_data/left%03d.jpg',i+1))));
    im2 = im2double(rgb2gray(imread(sprintf('/home/ed/Downloads/cmu_16662_p2/sensor_data/right%03d.jpg',i+1))));

    [worldPoints2,features2,xy2] = triangulateIm(im1,im2,K);

    [indexPairs] = matchFeatures(features1,features2,'MaxRatio',.4)

    wp1 = worldPoints1(:,indexPairs(:,1));
    wp2 = worldPoints2(:,indexPairs(:,2));
    [bestT bestI] = ransacRigidT(wp1,wp2,xy1(:,indexPairs(:,1)),xy2(:,indexPairs(:,2)),K,2000,1);
    THistory(i+1) = struct('T',bestT);
    fprintf('i = %d\n', i);
end

currentH = eye(4);
points = [];
for i=1:length(THistory)
    currentH = THistory(i).T*currentH;
    points = [points currentH*[0;0;0;1]];
end
points(1,:) = points(1,:)./points(4,:);
points(2,:) = points(2,:)./points(4,:);
points(3,:) = points(3,:)./points(4,:);
figure; hold on;
plot3(points(1,:),points(2,:),points(3,:));
hold off;




