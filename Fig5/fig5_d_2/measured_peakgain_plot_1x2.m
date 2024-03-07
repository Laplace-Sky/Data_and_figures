clear all; close all;
w_window = 1500;
h_window = 700;

line_width = 5;
line_width_loadtrace = 2.5;
line_width_circle = 2;
line_width_kcircle = 4;
marker = 'o';
markerSize = 3;
fontSize = 24;
smooth_index = 1;

color_order = get(gca,'colororder');
line_color = [0 0.4 1;
              0 0 0
              1 0 0];
          

%---------------------- plot for dataset 1 (REF)--------------------%
data_REF = load('REF_1x2.mat');


freq = data_REF.data.axes.data / 1e9; 
freq(352:end) = [];          % remove results for >4.5GHz
        
figure(1)
set(gcf,'position',[[200, 200], w_window, h_window]);
fill([1, 3.85, 3.85, 1],[-100,-100,100,100], [0.3010 0.7450 0.9330], 'LineStyle', 'none', 'FaceAlpha', 0.2, 'Handlevisibility', 'off');

hold on
x_line_l = xline(0.85, '--', [num2str(850),' MHz'], 'LineWidth', line_width-2, 'FontSize', fontSize-1, 'HandleVisibility', 'off', 'Color', 'black');
x_line_l.LabelVerticalAlignment = 'top';
x_line_l.LabelHorizontalAlignment = 'right';

x_line_h = xline(3.85, '--', [num2str(3850),' MHz'], 'LineWidth', line_width-2, 'FontSize', fontSize-1, 'HandleVisibility', 'off', 'Color', 'black');
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'left';


peakgain = data_REF.data.layers(2).data;
peakgain(352:end) = [];                                % remove results for >4.5GHz

plot(freq, smooth(peakgain, smooth_index), '-', 'linewidth', line_width, 'color', line_color(1, :));
ylabel('Peak Gain (dBi)', 'FontSize', fontSize); 


hold on
grid on

set(gca, 'FontSize', fontSize);
xlabel('Frequency (GHz)', 'FontSize', fontSize);
xlim([1 4.5])
ylim([-25 5])



%---------------------- plot for dataset 2 (NIP)--------------------%
data_NIP = load('NIP_1x2.mat');
  
figure(1)

peakgain = data_NIP.data.layers(2).data;
peakgain(352:end) = [];                                % remove results for >4.5GHz

plot(freq, smooth(peakgain, smooth_index), '-', 'linewidth', line_width, 'color', line_color(2, :));
ylabel('Peak Gain (dBi)', 'FontSize', fontSize); 


%---------------------- plot for dataset 3 (IP)--------------------%
data_IP = load('IP_1x2.mat');

figure(1)

peakgain = data_IP.data.layers(2).data;
peakgain(352:end) = [];                                % remove results for >4.5GHz

plot(freq, smooth(peakgain, smooth_index), '-', 'linewidth', line_width, 'color', line_color(3, :));
ylabel('Peak Gain (dBi)', 'FontSize', fontSize); 



x_line_h = xline(2.55, '--', ['TM_1_0 (REF)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(1, :));
x_line_h.LabelVerticalAlignment = 'bottom';
x_line_h.LabelHorizontalAlignment = 'left';

x_line_h = xline(2.1, '--', ['TM_1_0 (NIP)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(2, :));
x_line_h.LabelVerticalAlignment = 'bottom';
x_line_h.LabelHorizontalAlignment = 'left';

x_line_h = xline(2.25, '--', ['TM_1_0 (IP)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(3, :));
x_line_h.LabelVerticalAlignment = 'bottom';
x_line_h.LabelHorizontalAlignment = 'left';






Legend = {'Peak Gain (REF)', 'Peak Gain (NIP)', 'Peak Gain (IP)'};


%plot(HFSS_freq, HFSS_S11, ':', 'color', [0 0 0], 'linewidth', line_width);

legend(Legend, 'FontSize', 20, 'location', 'southeast');

%xline(2.17, '--', '2.17 GHz', 'linewidth', line_width, 'FontSize', fontSize, 'fontweight', 'bold', 'Handlevisibility', 'off', 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left')

