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
              0 0 0
              1 0 0];



filename = {'radiefficiency_1by2_REF.csv',
            'radiefficiency_1by2_NIP.csv',
            'radiefficiency_1by2_IP.csv'};
S11_filename = {'S11mag_1by2_REF.csv',
                'S11mag_1by2_NIP.csv',
                'S11mag_1by2_IP.csv'};


% filename = {'radiefficiency_2by2_REF.csv',
%             'radiefficiency_2by2_NIP.csv',
%             'radiefficiency_2by2_IP.csv'};
% S11_filename = {'S11mag_2by2_REF.csv',
%                 'S11mag_2by2_NIP.csv',
%                 'S11mag_2by2_IP.csv'};


% filename = {'radiefficiency_3by2_REF.csv',
%             'radiefficiency_3by2_NIP.csv',
%             'radiefficiency_3by2_IP.csv'};
% S11_filename = {'S11mag_3by2_REF.csv',
%                 'S11mag_3by2_NIP.csv',
%                 'S11mag_3by2_IP.csv'};


% filename = {'radiefficiency_nopattern_NIP.csv',
%             'radiefficiency_nopattern_IP.csv'};
% S11_filename = {'S11mag_nopattern_NIP.csv',
%                 'S11mag_nopattern_IP.csv'};
% line_color = [color_order(1, :);
%               color_order(2, :)
%               color_order(3, :)];


        
num_datagroup = length(filename);

figure(1)
set(gcf,'position',[[200, 200], w_window, h_window]);
fill([0.85, 3.85, 3.85, 0.85],[-100,-100,100,100], [0.3010 0.7450 0.9330], 'LineStyle', 'none', 'FaceAlpha', 0.2, 'Handlevisibility', 'off');
hold on
x_line_l = xline(0.85, '--', [num2str(850),' MHz'], 'LineWidth', line_width-2, 'FontSize', fontSize-1, 'HandleVisibility', 'off', 'Color', 'black');
x_line_l.LabelVerticalAlignment = 'top';
x_line_l.LabelHorizontalAlignment = 'right';

x_line_h = xline(3.85, '--', [num2str(3850),' MHz'], 'LineWidth', line_width-2, 'FontSize', fontSize-1, 'HandleVisibility', 'off', 'Color', 'black');
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'left';

for i = 1:num_datagroup
    data = csvread(char(filename(i)), 1, 0);  % skips the first row of data 
    S11_data = csvread(char(S11_filename(i)), 1, 0);  % skips the first row of data 
    freq = data(:, 1);
    efficiency = 100 * data(:, 2);
    S11mag = S11_data(:, 2);
    
    total_efficiency = efficiency .* abs(1 - abs(S11mag) .^ 2);

    if efficiency_select == 1
        plot(freq, smooth(total_efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(i, :));
        ylabel('Total Efficiency (%)', 'FontSize', fontSize); 
        Legend = {'REF', 'NIP', 'IP'};
    elseif efficiency_select == 0
        plot(freq, smooth(efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(i, :));
        ylabel('Radiation Efficiency (%)', 'FontSize', fontSize);  
        Legend = {'REF', 'NIP', 'IP'};
    else
        plot(freq, smooth(efficiency, smooth_index), '-', 'linewidth', line_width, 'color', line_color(i, :));
        plot(freq, smooth(total_efficiency, smooth_index), ':', 'linewidth', line_width, 'color', line_color(i, :));
        ylabel('Efficiency (%)', 'FontSize', fontSize);  
        Legend = {'\eta_{rad} (REF)', '\eta_{total} (REF)', '\eta_{rad} (NIP)', '\eta_{total} (NIP)', '\eta_{rad} (IP)', '\eta_{total} (IP)'};
    end
    
    hold on
    grid on
end


set(gca, 'FontSize', fontSize);
xlabel('Frequency (GHz)', 'FontSize', fontSize);
xlim([1 4.5])
ylim([0 100])




x_line_h = xline(2.57, '--', ['TM_1_0 (REF)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(1, :));
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'left';

x_line_h = xline(2.1, '--', ['TM_1_0 (NIP)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(2, :));
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'left';

x_line_h = xline(2.17, '--', ['TM_1_0 (IP)'], 'LineWidth', line_width, 'FontSize', fontSize-4, 'HandleVisibility', 'off', 'Color', line_color(3, :));
x_line_h.LabelVerticalAlignment = 'top';
x_line_h.LabelHorizontalAlignment = 'right';




%plot(HFSS_freq, HFSS_S11, ':', 'color', [0 0 0], 'linewidth', line_width);

legend(Legend, 'FontSize', 20, 'location', 'northeast');

%xline(2.17, '--', '2.17 GHz', 'linewidth', line_width, 'FontSize', fontSize, 'fontweight', 'bold', 'Handlevisibility', 'off', 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left')

