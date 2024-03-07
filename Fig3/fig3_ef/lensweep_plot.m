clear all; close all;
load('lensweep_5-1-100_results.mat');

line_width = 6;
marker = 'o';
markerSize = 3;
fontSize = 28.5;

color_single = [0 0.4 1];
color_both = [1 0 0];
color_colorcircle = [0 0 0];

figure
set(gcf, 'Position',  [200, 200, 2000, 800])
plot(seg_len(1:96), area_percent_singlestub(1:96), 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_single)
hold on
plot(seg_len(1:96), area_percent(1:96), 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_both)
plot(seg_len(1:96), cover_circle_area_percent(1:96), 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_colorcircle)

xlim([0 105])
ylim([0 1])

xticks(0:5:100)
yticks(0:0.1:1)
xticklabels({char(split(num2str(0:5:100)))})
yticklabels({'0%', '10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'})

xlabel('Transmission line segment unit length (mm)')
ylabel({'Percentage of matched impedance area'; 'on Smith chart'})

%set(gca, 'fontsize', fontSize)

%title('Percentage of matched impedance area in Smith chart V.S. Transmission line segment unit length')

xline = xline(14, '--', [num2str(14),' mm'], 'LineWidth', line_width, 'FontSize', 22, 'HandleVisibility', 'off');
xline.LabelVerticalAlignment = 'bottom';
xline.LabelHorizontalAlignment = 'left';


text(seg_len(10) + 0.6, area_percent(10) + 0.03, sprintf('%.2f%%', 100*area_percent(10)), 'FontSize', fontSize, 'fontweight', 'bold', 'HorizontalAlignment', 'left', 'Color', color_both);
text(seg_len(10) + 4.2, area_percent_singlestub(10) + 0.07, sprintf('%.2f%%', 100*area_percent_singlestub(10)), 'FontSize', fontSize, 'fontweight', 'bold', 'HorizontalAlignment', 'right', 'Color', color_single);
text(seg_len(10) - 1.5, cover_circle_area_percent(10) - 0.05, sprintf('%.2f%%', 100*cover_circle_area_percent(10)), 'FontSize', fontSize, 'fontweight', 'bold', 'HorizontalAlignment', 'left', 'Color', color_colorcircle);

legend('Single-stub matching', 'Single-stub and double-stub matching', 'Maximum circle area enclosed', 'Location', 'northeast', 'fontsize', fontSize);

set(gca, 'FontSize', fontSize);

