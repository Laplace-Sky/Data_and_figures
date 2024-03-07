clear all; close all;


scale = 1;      %determines the resolution
window_size = 1050;      % this decides the png picture resolutions, higher the number, higher the percentage precision but longer calculation time
color_outline = [1 0 0];     %red

line_width = 2;

f = 2.45; %GHz
k = 0.2;
len = 5;  %mm


%smith
figure('Name', 'Smith chart outline only');
set(gcf,'position',[1100,50,scale*window_size,scale*window_size]);                             % the graph setting should be maintained the same to get same output png file resolutions
smithplot(0, 'GridVisible', 0, 'ColorOrder', [0 0 0], 'LineWidth', 0.1, 'ArcTickLabelVisible', 0, 'CircleTickLabelVisible', 0); % the Smith chart circle (used to be minused later)
saveas(gcf, 'Smith_circle.png')
I = imread('Smith_circle.png');
Smith_circle = im2bw(I, 0.9);
Smith_circle_filled = ones(size(Smith_circle));                   %containing zeros as overall smith chart area

[B0,L,N0,A] = bwboundaries(Smith_circle, 8, 'holes');
boundary_smith_inner = B0{2};   



figure('Name', 'Smithn_outline');
set(gcf,'position',[0,0,scale*window_size,scale*window_size]);
I_final = imread('Smith_final.png');
imshow(I_final);
hold on;
I = imread('Smith.png');
Smith_circle_outline = im2bw(I, 0.9);

%clear the inner Smith circle to prevent continued circle to inner side
for i = 1:length(boundary_smith_inner)
    Smith_circle_outline(boundary_smith_inner(i,2), boundary_smith_inner(i,1)) = 1;
end

[B0,L0,N0,A0] = bwboundaries(Smith_circle_outline, 8, 'holes');


for p = N0 + 2 : length(B0)
    boundary = B0{p}; 
    
    if (boundary(1, 1) == 1218) && boundary(1, 2) == 390
        continue
    end
    
    boundary(:, 2) = smooth(boundary(:, 2));
    boundary(:, 1) = smooth(boundary(:, 1));
    plot(boundary(:,2), boundary(:,1), 'Color', color_outline, 'LineWidth', line_width);
    hold on
end 
% 
% filename_savefig_fill = sprintf('Filled_k=%.2f_%dmm_%.2fG_numV=5.png', k, len, f);

% %plot inner vacancy outline
% I_filled = imread(filename_savefig_fill);
% Smith_circle_fill = im2bw(I_filled, 0.9);
% [B1,L1,N1,A1] = bwboundaries(Smith_circle_fill, 8, 'holes');
% for p = 3 : N1 
%     boundary = B1{p}; 
%     boundary(:, 2) = smooth(boundary(:, 2));
%     boundary(:, 1) = smooth(boundary(:, 1));
%     plot(boundary(:,2), boundary(:,1), 'Color', color_outline, 'LineWidth', line_width);
%     hold on
% end 