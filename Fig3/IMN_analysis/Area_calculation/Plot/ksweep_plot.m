clear all; close all;
load('ksweep_0.05-0.05-0.5_results.mat');

line_width = 4;
marker = 'o';
markerSize = 3;
fontSize = 20;

color_single = [0.2 0.75 0];
color_both = [1 0 0];
color_colorcircle = [0.3 0.3 0.3];

% add k=0 to the plot
seg_k = [0 seg_k];
area_percent_singlestub = [0 area_percent_singlestub];
area_percent = [0 area_percent];
cover_circle_area_percent = [0 cover_circle_area_percent];

num_file = 1;
for k = 0.05:0.05:0.5
    VSWR(num_file) = (1 + k)/(1 - k);
    num_file = num_file + 1;
end

figure
set(gcf, 'Position',  [200, 100, 1300, 800])
plot(seg_k, area_percent_singlestub, 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_single)
hold on
plot(seg_k, area_percent, 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_both)
plot(seg_k, cover_circle_area_percent, 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_colorcircle)


xlim([0 0.52])
ylim([0 1])

xticks(0:0.05:0.5)
yticks(0:0.1:1)
% for ploting two-row x axis
ax = gca(); 
labelArray = [{'0', '0.05', '   0.1', '0.15', '  0.2', '0.25', '   0.3', '0.35', '   0.4', '0.45', ' 0.5'};...
              {'1', '(1.11)', '(1.22)', '(1.35)', '(1.5)', '(1.67)', '(1.86)', '(2.08)', '(2.33)', '(2.64)', '(3)'}];
tickLabel = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
ax.XTickLabel = tickLabel;
yticklabels({'0%', '10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'})

xlabelArray = [{'Acceptable impedance matched reflection coefficient circle radius k'}; {'(Corresponeding maixmum accetable VSWR)'}];
Label = strtrim(sprintf('%s\\newline     %s\n', xlabelArray{:}));
xlabel(Label)
ylabel('Percentage of matched impedance area in Smith chart')

%title('Percentage of matched impedance area in Smith chart V.S. Transmission line segment unit length')

xline = xline(0.2, '--', num2str(0.2), 'LineWidth', line_width, 'FontSize', 18, 'HandleVisibility', 'off');
xline.LabelVerticalAlignment = 'bottom';
xline.LabelHorizontalAlignment = 'right';

text(seg_k(5)-0.004, area_percent(5)+0.01, sprintf('%.2f%%', 100*area_percent(5)), 'FontSize', fontSize, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', color_both);
text(seg_k(5)-0.005, area_percent_singlestub(5)+0.02, sprintf('%.2f%%', 100*area_percent_singlestub(5)), 'FontSize', fontSize, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', color_single);
text(seg_k(5)+0.005, cover_circle_area_percent(5)-0.012, sprintf('%.2f%%', 100*cover_circle_area_percent(5)), 'FontSize', fontSize, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'Color', color_colorcircle);

legend('Single-stub matching', 'Single-stub and double-stub matching', 'Maximum circle area enclosed', 'Location', 'southeast');

set(gca, 'FontSize', 18);
