clear all; close all
w_window = 750;
h_window = 600;

fontsize = 23;

gain_offset = -25;

gain = [-6.8 -3.2 -0.7;      %REF
       -14 -15 -13.8;       %NIP
       0.5 -4.1 0.7];         %IP

efficiency = [0.055 0.063 0.138; %REF
              0.012 0.005 0.007; %NIP
              0.32 0.133 0.248]; %IP

antenna_type = [1 2 3];
gain_freq1 = [gain(1, 1) gain_offset; gain(2, 1) gain_offset; gain(3, 1) gain_offset]- gain_offset;
gain_freq2 = [gain(1, 2) gain_offset; gain(2, 2) gain_offset; gain(3, 2) gain_offset]- gain_offset;
gain_freq3 = [gain(1, 3) gain_offset; gain(2, 3) gain_offset; gain(3, 3) gain_offset]- gain_offset;

efficiency_freq1 = [0 efficiency(1, 1); 0 efficiency(2, 1); 0 efficiency(3, 1)];
efficiency_freq2 = [0 efficiency(1, 2); 0 efficiency(2, 2); 0 efficiency(3, 2)];
efficiency_freq3 = [0 efficiency(1, 3); 0 efficiency(2, 3); 0 efficiency(3, 3)];


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
    text(antenna_type(i) - 0.35, gain_freq1(i, 1), num2str(gain_freq1(i, 1) + gain_offset,'%0.1f'),...
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
    text(antenna_type(i) - 0.35, gain_freq2(i, 1), num2str(gain_freq2(i, 1) + gain_offset,'%0.1f'),...
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
%title('TM_2_0', 'fontsize', 27)



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
%title('TM_2_1', 'fontsize', 27)

