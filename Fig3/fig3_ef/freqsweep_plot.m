clear all; close all;
load('freqsweep_0.1-0.1-4.5_results.mat');

line_width = 6;
marker = 'o';
markerSize = 3;
fontSize = 28.5;

color_single = [0 0.4 1];
color_both = [1 0 0];
color_colorcircle = [0 0 0];

% add k=0 to the plot

figure
set(gcf, 'Position',  [200, 100, 2000, 800])
plot(seg_f, area_percent_singlestub, 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_single)
hold on
plot(seg_f, area_percent, 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_both)
plot(seg_f, cover_circle_area_percent, 'LineWidth', line_width, 'Marker', marker, 'MarkerSize', markerSize, 'Color', color_colorcircle)


xlim([0 4.6])
ylim([0 1])

xticks([0:0.5:4.5])
yticks(0:0.1:1)
% for ploting two-row x axis
ax = gca(); 
row1 = {};
row2 = {};
for j = 1:23

    row1(end+1) = {num2str(round(0.5 * (j - 1), 1))};

    row2(end+1) = {'G'};
    j = j + 1;
end
labelArray = [row1; row2];
tickLabel = strtrim(sprintf('%s%s\n', labelArray{:}));
ax.XTickLabel = tickLabel;
yticklabels({'0%', '10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'})

xlabel('Frequency (GHz)')
ylabel({'Percentage of matched impedance area'; 'on Smith chart'})

%title('Percentage of matched impedance area in Smith chart V.S. Transmission line segment unit length')

xline = xline(2.45, '--', [num2str(2.45),' GHz'], 'LineWidth', line_width, 'FontSize', 22, 'HandleVisibility', 'off');
xline.LabelVerticalAlignment = 'bottom';
xline.LabelHorizontalAlignment = 'right';

yline = yline(0.5, '--', '50%', 'LineWidth', line_width, 'FontSize', 22, 'HandleVisibility', 'off');
yline.LabelHorizontalAlignment = 'left';


text(seg_f(25) - 0.015, area_percent(25) + 0.03, sprintf('%.2f%%', 100*area_percent(25)), 'FontSize', fontSize, 'fontweight', 'bold', 'HorizontalAlignment', 'right', 'Color', color_both);
text(seg_f(25) -0.015, area_percent_singlestub(25) + 0.025, sprintf('%.2f%%', 100*area_percent_singlestub(25)), 'FontSize', fontSize, 'fontweight', 'bold', 'HorizontalAlignment', 'right', 'Color', color_single);
text(seg_f(25) + 0.01, cover_circle_area_percent(25) + 0.035, sprintf('%.2f%%', 100*cover_circle_area_percent(25)), 'FontSize', fontSize, 'fontweight', 'bold', 'HorizontalAlignment', 'left', 'Color', color_colorcircle);

legend('Single-stub matching', 'Single-stub and double-stub matching', 'Maximum circle area enclosed', 'Location', 'northeast', 'fontsize', fontSize);

set(gca, 'FontSize', fontSize);

