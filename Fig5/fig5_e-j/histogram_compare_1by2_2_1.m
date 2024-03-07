clear all; close all
w_window = 750;
h_window = 600;

fontsize = 23;

gain_offset = -25;

antenna_type = [1 2 3];


%measured
gain_freq1 = [3 gain_offset; -9.7 gain_offset; -0.7 gain_offset]- gain_offset;
gain_freq2 = [-5.9 gain_offset; -14.4 gain_offset; 1 gain_offset]- gain_offset;
gain_freq3 = [-2.6 gain_offset; -5.5 gain_offset; -2.6 gain_offset]- gain_offset;

efficiency_freq1 = [0 0.41; 0 0.018; 0 0.22];
efficiency_freq2 = [0 0.099; 0 0.01; 0 0.257];
efficiency_freq3 = [0 0.125; 0 0.048; 0 0.153];

gain = [3.2 -11.9 -8.7;      %REF
       -9.7 -20.2 -3.7;       %NIP
       -0.7 -7.1 -3];         %IP

efficiency = [0.481 0.136 0.144; %REF
              0.027 0.012 0.088; %NIP
              0.354 0.39 0.278]; %IP

fig = figure(1);
set(gcf,'position',[[200, 200], w_window, h_window]);
set(fig,'defaultAxesColorOrder',[0.8500    0.3250    0.0980; 0    0.4470    0.7410]);
yyaxis left
b1 = bar(antenna_type, gain_freq1, 'FaceColor', [0.8500    0.3250    0.0980])
set(gca, 'Fontsize', fontsize + 5)
set(gca, 'YLim', [0, -gain_offset + 5])
set(gca, 'YTickLabel', [gain_offset:10:5])
hold on
for i = 1:length(antenna_type)
    text(antenna_type(i) - 0.27, gain_freq1(i, 1), num2str(gain_freq1(i, 1) + gain_offset,'%0.1f'),...
        'vert','bottom', 'color', [0.8500    0.3250    0.0980], 'Fontsize', fontsize, 'fontweight', 'bold');
end
ylabel('Peak Gain (dBi)');

yyaxis right
b2 = bar(antenna_type, efficiency_freq1, 'FaceColor', [0    0.4470    0.7410])
set(gca, 'YLim', [0, 0.6])
set(gca, 'YTick', [0 0.2 0.4 0.6])
set(gca, 'YTickLabel', {'0%', '20%', '40%', '60%'})%{'0%', '10%', '20%', '30%', '40%', '50%', '60%'})
for i = 1:length(antenna_type)
    text(antenna_type(i) - 0.05, efficiency_freq1(i, 2), sprintf('%0.1f%%', 100 * efficiency_freq1(i, 2)),...
        'vert','bottom', 'color', [0    0.4470    0.7410], 'Fontsize', fontsize, 'fontweight', 'bold');
end
ylabel('Radiation Efficiency');

xticklabels({'REF', 'NIP', 'IP'});
%title('TM_1_0', 'fontsize', 27)



fig = figure(2);
set(gcf,'position',[[200, 200], w_window, h_window]);
set(fig,'defaultAxesColorOrder',[0.8500    0.3250    0.0980; 0    0.4470    0.7410]);
yyaxis left
bar(antenna_type, gain_freq2, 'FaceColor', [0.8500    0.3250    0.0980])
set(gca, 'Fontsize', fontsize + 5)
set(gca, 'YLim', [0, -gain_offset + 5])
set(gca, 'YTickLabel', [gain_offset:10:5])
hold on
for i = 1:length(antenna_type)
    text(antenna_type(i) - 0.32, gain_freq2(i, 1), num2str(gain_freq2(i, 1) + gain_offset,'%0.1f'),...
        'vert','bottom', 'color', [0.8500    0.3250    0.0980], 'Fontsize', fontsize, 'fontweight', 'bold');
end
ylabel('Peak Gain (dBi)');

yyaxis right
bar(antenna_type, efficiency_freq2, 'FaceColor', [0    0.4470    0.7410])
set(gca, 'YLim', [0, 0.6])
set(gca, 'YTick', [0 0.2 0.4 0.6])
set(gca, 'YTickLabel', {'0%', '20%', '40%', '60%'})%{'0%', '10%', '20%', '30%', '40%', '50%', '60%'})
for i = 1:length(antenna_type)
    text(antenna_type(i) - 0.05, efficiency_freq2(i, 2), sprintf('%0.1f%%', 100 * efficiency_freq2(i, 2)),...
        'vert','bottom', 'color', [0    0.4470    0.7410], 'Fontsize', fontsize, 'fontweight', 'bold');
end
ylabel('Radiation Efficiency');

xticklabels({'REF', 'NIP', 'IP'});
%title('TM_0_2', 'fontsize', 27)



fig = figure(3);
set(gcf,'position',[[200, 200], w_window, h_window]);
set(fig,'defaultAxesColorOrder',[0.8500    0.3250    0.0980; 0    0.4470    0.7410]);
yyaxis left
bar(antenna_type, gain_freq3, 'FaceColor', [0.8500    0.3250    0.0980])
set(gca, 'Fontsize', fontsize + 5)
set(gca, 'YLim', [0, -gain_offset + 5])
set(gca, 'YTickLabel', [gain_offset:10:5])
hold on
for i = 1:length(antenna_type)
    text(antenna_type(i) - 0.35, gain_freq3(i, 1), num2str(gain_freq3(i, 1) + gain_offset,'%0.1f'),...
        'vert','bottom', 'color', [0.8500    0.3250    0.0980], 'Fontsize', fontsize, 'fontweight', 'bold');
end
ylabel('Peak Gain (dBi)');

yyaxis right
bar(antenna_type, efficiency_freq3, 'FaceColor', [0    0.4470    0.7410])
set(gca, 'YLim', [0, 0.6])
set(gca, 'YTick', [0 0.2 0.4 0.6])
set(gca, 'YTickLabel', {'0%', '20%', '40%', '60%'})%{'0%', '10%', '20%', '30%', '40%', '50%', '60%'})
for i = 1:length(antenna_type)
    text(antenna_type(i) - 0.05, efficiency_freq3(i, 2), sprintf('%0.1f%%', 100 * efficiency_freq3(i, 2)),...
        'vert','bottom', 'color', [0    0.4470    0.7410], 'Fontsize', fontsize, 'fontweight', 'bold');
end
ylabel('Radiation Efficiency');

xticklabels({'REF', 'NIP', 'IP'});
%title('TM_1_2 (outside dynamic BW)', 'fontsize', 27)

