clear all
close all

f = 2.45; %GHz
k = 0.2;
len = 1;  %cm

filename = sprintf('test_two stub_k=%.1f_%dcm_%.2fG.png', k, len, f);
I = imread(filename);
BW = im2bw(I,0.8);

[B,L,N,A] = bwboundaries(BW ,8, 'holes');

figure(1)
imshow(BW);
hold on
for k = 1:length(B)
   boundary = B{k};
  if (k > N)      
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
  end
end


