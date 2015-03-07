function [worldPoints] = triangulate(pts1,pts2,P1,P2)
figure;
hold on;
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
      V 
    h = V(:,end)    
    rp = P1*h;
    worldPoints = [worldPoints h/h(4)];
    plot(pts1(1,i),pts1(2,i),'.r');
    plot(rp(1)/rp(3),rp(2)/rp(3),'ob');
    
end
hold off;

hold on;
figure ;plot3(worldPoints(1,:),worldPoints(2,:),worldPoints(3,:),'.g');
end