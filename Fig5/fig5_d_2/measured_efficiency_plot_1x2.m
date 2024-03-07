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

efficiency_select = 2;  % 0 for radi efficiency and 1 for total efficiency 2 for all together

color_order = get(gca,'colororder');
line_color = [0 0.4 1;
              0 0 0;
              1 0 0];


%---------------------- plot for dataset 1 (REF)--------------------%
data_REF = load('REF_1x2.mat');
S11_data = csvread('S11_1BY2_REF.CSV', 3, 0);  % skips the first row of data 
S11mag = 10 .^ (interp1(S11_data(:, 1), S11_data(:, 2), [1e9: 1e7: 4.5e9]) / 20);  % interpolation of S11 measured to match the freq points

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


efficiency = 10 .^ (data_REF.data.layers(3).data / 10);  % convert to percentage
efficiency(352:end) = [];                                % remove results for >4.5GHz

total_efficiency = efficiency .* abs(1 - abs(S11mag) .^ 2);

if efficiency_select == 1
    plot(freq, smooth(100 * total_efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(1, :));
    ylabel('Total Efficiency (%)', 'FontSize', fontSize); 
elseif efficiency_select == 0
    plot(freq, smooth(100 * efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(1, :));
    ylabel('Radiation Efficiency (%)', 'FontSize', fontSize);  
else
    plot(freq, smooth(100 * efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(1, :));
    plot(freq, smooth(100 * total_efficiency, smooth_index), ':', 'linewidth', line_width, 'color', line_color(1, :));
    ylabel('Efficiency (%)', 'FontSize', fontSize);  
end

hold on
grid on

set(gca, 'FontSize', fontSize);
xlabel('Frequency (GHz)', 'FontSize', fontSize);
xlim([1 4.5])
ylim([0 100])



%---------------------- plot for dataset 2 (NIP)--------------------%
data_NIP = load('NIP_1x2.mat');
S11_data = csvread('S11_1BY2_NIP.CSV', 3, 0);  % skips the first row of data 
S11mag = 10 .^ (interp1(S11_data(:, 1), S11_data(:, 2), [1e9: 1e7: 4.5e9]) / 20);  % interpolation of S11 measured to match the freq points
  
figure(1)

efficiency = 10 .^ (data_NIP.data.layers(3).data / 10);  % convert to percentage
efficiency(352:end) = [];                                % remove results for >4.5GHz

total_efficiency = efficiency .* abs(1 - abs(S11mag) .^ 2);

if efficiency_select == 1
    plot(freq, smooth(100 * total_efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(2, :));
    ylabel('Total Efficiency (%)', 'FontSize', fontSize); 
elseif efficiency_select == 0
    plot(freq, smooth(100 * efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(2, :));
    ylabel('Radiation Efficiency (%)', 'FontSize', fontSize);  
else
    plot(freq, smooth(100 * efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(2, :));
    plot(freq, smooth(100 * total_efficiency, smooth_index), ':', 'linewidth', line_width, 'color', line_color(2, :));
    ylabel('Efficiency (%)', 'FontSize', fontSize);  
end


%---------------------- plot for dataset 3 (IP)--------------------%
data_IP = load('IP_1x2.mat');
S11_data = csvread('S11_1BY2_IP.CSV', 3, 0);  % skips the first row of data 
S11mag = 10 .^ (interp1(S11_data(:, 1), S11_data(:, 2), [1e9: 1e7: 4.5e9]) / 20);  % interpolation of S11 measured to match the freq points

figure(1)

efficiency = 10 .^ (data_IP.data.layers(3).data / 10);  % convert to percentage
efficiency(352:end) = [];                                % remove results for >4.5GHz

total_efficiency = efficiency .* abs(1 - abs(S11mag) .^ 2);

if efficiency_select == 1
    plot(freq, smooth(100 * total_efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(3, :));
    ylabel('Total Efficiency (%)', 'FontSize', fontSize); 
elseif efficiency_select == 0
    plot(freq, smooth(100 * efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(3, :));
    ylabel('Radiation Efficiency (%)', 'FontSize', fontSize);  
else
    plot(freq, smooth(100 * efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(3, :));
    plot(freq, smooth(100 * total_efficiency, smooth_index), ':', 'linewidth', line_width, 'color', line_color(3, :));
    ylabel('Efficiency (%)', 'FontSize', fontSize);  
end




x_line_h = xline(2.55, '--', ['TM_1_0 (REF)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(1, :));
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'left';

x_line_h = xline(2.1, '--', ['TM_1_0 (NIP)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(2, :));
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'left';

x_line_h = xline(2.25, '--', ['TM_1_0 (IP)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(3, :));
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'left';




Legend = {'\eta_{rad} (REF)', '\eta_{total} (REF)', '\eta_{rad} (NIP)', '\eta_{total} (NIP)', '\eta_{rad} (IP)', '\eta_{total} (IP)'};


%plot(HFSS_freq, HFSS_S11, ':', 'color', [0 0 0], 'linewidth', line_width);

legend(Legend, 'FontSize', 20, 'location', 'northeast');

%xline(2.17, '--', '2.17 GHz', 'linewidth', line_width, 'FontSize', fontSize, 'fontweight', 'bold', 'Handlevisibility', 'off', 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left')

