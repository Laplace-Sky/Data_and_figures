clear all; close all;
w_window = 1600;
h_window = 800;

linewidth = 6;
plot_patch = 1;
plot_IP = 1;   %modify here for plotting NIP and ref or IP and NIP
plot_sim = 1;

fontsize = 27;

color_patch = [0 0.4 1];%color_NIP;%[0.6 0.6 0.6];
color_NIP = [0 0 0];

antenna_type = '1BY2';

Legend = [];



figure;
hold on
set(gcf,'position',[[20, 20], w_window, h_window]);

fill([0.85, 3.85, 3.85, 0.85],[-100,-100,100,100], [0.3010 0.7450 0.9330], 'LineStyle', 'none', 'FaceAlpha', 0.2, 'Handlevisibility', 'off');
x_line_l = xline(0.85, '--', 'LineWidth', linewidth-2, 'HandleVisibility', 'off', 'Color', 'black');
x_line_l.LabelVerticalAlignment = 'bottom';
x_line_l.LabelHorizontalAlignment = 'left';
text(0.94, -19, '850 MHz', 'rotation', 90, 'fontsize', fontsize);

x_line_h = xline(3.85, '--', [num2str(3850),' MHz'], 'LineWidth', linewidth-2, 'FontSize', fontsize, 'HandleVisibility', 'off', 'Color', 'black');
x_line_h.LabelVerticalAlignment = 'bottom';
x_line_h.LabelHorizontalAlignment = 'left';

text(2.05, -26.8, 'TM_1_0', 'fontsize', fontsize - 3, 'fontweight', 'bold');
text(2.55, -30, 'TM_0_2', 'fontsize', fontsize - 3, 'fontweight', 'bold');
text(3.95, -15, 'TM_1_2', 'fontsize', fontsize - 3);

if plot_patch
    data = csvread([antenna_type, '_', 'PATCH.csv'], 3, 0);  
    plot(data(:, 1) / 1e9, min(0, data(:, 2)), 'LineWidth', linewidth, 'Color', color_patch);
    Legend = [Legend; "Patch reference (measured)"];
    
    if plot_sim
        data = csvread([antenna_type, '_', 'PATCH_sim.csv'], 3, 0);  
        plot(data(:, 1), data(:, 2), 'LineWidth', linewidth, 'Color', color_patch, 'Linestyle', ':');
        Legend = [Legend; "Patch reference (simulated)"];
    end

    set(gcf,'position',[[20, 20], w_window, h_window]);

end

data = csvread([antenna_type, '.csv'], 3, 0);  
plot(data(:, 1) / 1e9, data(:, 2), 'LineWidth', linewidth, 'Color', color_NIP);

Legend = [Legend; sprintf('NIP FPRFS patch (measured)')];

hold on

if plot_sim
    data = csvread([antenna_type, '_sim' '.csv'], 1, 0);
    plot(data(:, 1), data(:, 2), 'LineWidth', linewidth, 'Color', color_NIP, 'Linestyle', ':');
    Legend = [Legend; "NIP FPRFS patch (simulated)"];
end


%title(['S11 plot for ', antenna_type], 'Interpreter', 'none', 'FontSize', 15)

if plot_IP
    data = csvread([antenna_type, '_', 'IP.csv'], 3, 0);  
    plot(data(:, 1) / 1e9, min(0, data(:, 2)), 'LineWidth', linewidth, 'Color', 'red');
    Legend = [Legend; "IP FPRFS patch (measured)"];
    
    if plot_sim
        data = csvread([antenna_type, '_', 'IP_sim.csv'], 3, 0);  
        plot(data(:, 1), data(:, 2), 'LineWidth', linewidth, 'Color', 'red', 'Linestyle', ':');
        Legend = [Legend; "IP FPRFS patch (simulated)"];
    end

    set(gcf,'position',[[20, 20], w_window, h_window]);
    
end


if strcmp(antenna_type, '2BY3')
%     x_measured = xline(2.12, '--', [num2str(2.12),' GHz'], 'LineWidth', linewidth, 'FontSize', 15, 'HandleVisibility', 'off', 'Color', 'black');
%     x_measured.LabelVerticalAlignment = 'bottom';
%     x_measured.LabelHorizontalAlignment = 'left';
%     
%     if plot_patch%2.55
%         x_simulated = xline(2.22, '--', [num2str(2.22),' GHz'], 'LineWidth', linewidth, 'FontSize', 15, 'HandleVisibility', 'off', 'Color', 'red');
%         x_simulated.LabelVerticalAlignment = 'bottom';
%         x_simulated.LabelHorizontalAlignment = 'left';
%     elseif plot_IP
%         x_simulated = xline(2.22, '--', [num2str(2.22),' GHz'], 'LineWidth', linewidth, 'FontSize', 15, 'HandleVisibility', 'off', 'Color', 'red');
%         x_simulated.LabelVerticalAlignment = 'bottom';
%         x_simulated.LabelHorizontalAlignment = 'right';
%     end
%     
%     title(sprintf('Comparison between FPRFS emulated and conventional reference patch antennas (1by2-2-1)'));
% elseif strcmp(antenna_type, '3BY3')
%     x_measured = xline(1.45, '--', [num2str(1.45),' GHz'], 'LineWidth', linewidth, 'FontSize', 15, 'HandleVisibility', 'off', 'Color', 'black');
%     x_measured.LabelVerticalAlignment = 'bottom';
%     
%     if plot_patch%1.36
%         x_simulated = xline(1.3, '--', [num2str(1.3),' GHz'], 'LineWidth', linewidth, 'FontSize', 15, 'HandleVisibility', 'off', 'Color', 'red');
%         x_simulated.LabelVerticalAlignment = 'bottom';
%         x_simulated.LabelHorizontalAlignment = 'left';
%     elseif plot_IP
%         x_simulated = xline(1.3, '--', [num2str(1.3),' GHz'], 'LineWidth', linewidth, 'FontSize', 15, 'HandleVisibility', 'off', 'Color', 'red');
%         x_simulated.LabelVerticalAlignment = 'bottom';
%         x_simulated.LabelHorizontalAlignment = 'left';
%     end
    
    %title(sprintf('Comparison between FPRFS emulated and conventional reference patch antennas (1by2-2-1)'));

end

if plot_IP
    %title(sprintf('Comparison between FPRFS emulated patch antennas with different SMA polarities (1by2-2-1)'));
    %title(sprintf('S11 of reference patch antenna and FPRFS emulated antennas with NIP and IP feeders'));
end

legend(Legend, 'FontSize', fontsize, 'Location', 'southwest');
ylim([-35,0]);

set(gca, 'FontSize', fontsize);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S11| (dB)', 'FontSize', fontsize);
grid on


