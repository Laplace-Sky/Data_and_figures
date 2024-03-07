clear all; close all
w_window = 1800;
h_window = 800;

fontsize = 24;

plot_density = 0;

smooth_index = 15;
load_color = [0 0 0];%[0.6 0.6 0.6];

plot_LH = 0;  % plot 850MHz and 4.4GHz

plot_envelope = 0;

path = pwd;
%path = 'C:\Users\tianzhil\OneDrive - The University of Melbourne\PhD\Experiment\Configurable RF surface\MATLAB\Anechoic chamber measurement\FPRFS_IMN_S11_opti\cascadingIMN_IPpatch\All\IP1BY2';
pattern_folder = dir(path);
filenames = {pattern_folder(:).name};
%csvfiles = natsortfiles(filenames(startsWith(filenames, 'S11_IP1BY2_SINGLE_')));
csvfiles = natsortfiles(filenames(startsWith(filenames, 'new_')));
MAX_file_num = length(csvfiles);

window_size = 65;
%window_size = 72; %about 100MHz
%window_size = round(-1.07 * MAX_file_num + 93.4);

FREQ_num = 1601;
FREQ_num_start = 850; %MHz
FREQ_num_end = 3850; %MHz
FREQ_num_start_index = round((FREQ_num_start - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;
FREQ_num_end_index = round((FREQ_num_end - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;


freq_min = zeros(FREQ_num, MAX_file_num);
S11_min = zeros(FREQ_num, MAX_file_num);
S11_100MHz_max = -100;
S11_4500MHz_max = -100;

freq_bandwidth_L = FREQ_num;
S11_bandwidth_L = 0;
freq_bandwidth_H = 0;
S11_bandwidth_H = 0;

figure
set(gcf,'position',[[20, 20], w_window, h_window]);
Legend = [];
num_pattern = 0;
% newcolors = [0.1 0.1 0.1;
%                0.1 0.65 0.1;
%                1 0.2 0.2];
% colororder(newcolors);
color_order = get(gca, 'colororder');

%1.0G 1.2G 1.5G 1.8G 2.0G 2.1G 2.4G 2.45G
pattern_num_highlight = [1200 5;...
                         1800 24;...
                         2400 0 ;...
                         ]


legend_flag = 0;

%plot load
% T = csvread(['DIPOLE', '_R_1601points', '.csv'], 3, 0);
% freq = T(:, 1);
% re_load = T(:, 2);
% T = csvread(['DIPOLE', '_X_1601points', '.csv'], 3, 0);
% im_load = T(:, 2);
% T = csvread(['S11_DIPOLE', '_1601points', '.csv'], 3, 0);

T_ = csvread(['1BY2_IP.CSV'], 3, 0);
freq = T_(:, 1);
S11_load_mag_ = T_(:, 2);
% for m = 1:length(T_)
%     S11_load(m) = complex(re_load(m), im_load(m));
%     S11_load_mag(m) = 10*log(S11_load(m));
% end
plot(freq / 1e9,  smooth(S11_load_mag_, smooth_index), ':', 'LineWidth', 6, 'color', load_color);
hold on

for i = 1:MAX_file_num 

    T = csvread([path '\' char(csvfiles(i))], 3, 0);  % skips the first three rows of data
    freq = T(:, 1);
    S11(:, i) = T(:, 2);

    num_pattern = num_pattern + 1;

    if(S11(1, i) > S11_100MHz_max)
        S11_100MHz_max = S11(1, i);
    end

    if(S11(FREQ_num, i) > S11_4500MHz_max)
        S11_4500MHz_max = S11(FREQ_num, i);
    end

    freq_min_current(:, i) = islocalmin(S11(:, i));

    % to find all the minimum index and S11 value
    for k = 1:FREQ_num
        if(freq_min_current(k, i) == 1)
            if(S11(k, i) < -10)
                if(S11(k, i) < S11_min(k, i))
                    S11_min(k, i) = S11(k, i);
                end
            else
                freq_min_current(k, i) = 0;
            end
        end
    end

    freq_min(:, i) = bitor(freq_min(:, i), freq_min_current(:, i));

    % to find the -10dB bandwidth low and high limits
    for k = FREQ_num_start_index:FREQ_num_end_index
        %low
        if((S11(k - 1, i) > -10) & (S11(k, i) <= -10))
            if(k <= freq_bandwidth_L)
                freq_bandwidth_L = k;
                S11_bandwidth_L = S11(k, i);
            end
        end
        %high
        if((S11(k, i) <= -10) & (S11(k + 1, i) > -10))
            if(k >= freq_bandwidth_H)
                freq_bandwidth_H = k;
                S11_bandwidth_H = S11(k, i);
            end
        end
    end

%     if ismember(i-1, pattern_num_highlight(:, 2))
% %         color_count = color_count + 1;
% %         plot(freq / 1e9,  S11(:, i), '-', 'Color', color_order(color_count, :), 'LineWidth', 4);
%     else
        if ~legend_flag
            plot(freq / 1e9,  smooth(S11(:, i), smooth_index), ':', 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 2);
            legend_flag = 1;
        else
            plot(freq / 1e9,  smooth(S11(:, i), smooth_index), ':', 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 2, 'HandleVisibility', 'off');
        end
%     end


    hold on
    RL(:, i) =  S11(:, i);
end


color_count = 0;

T1 = csvread('allIMN_1.2G_double48.CSV', 3, 0);  % skips the first three rows of data
freq = T1(:, 1);
S11(:, 1) = T1(:, 2);

color_count = color_count + 1;
S11(:, 1) = smooth(S11(:, 1), smooth_index);
plot(freq / 1e9,  S11(:, 1), '-', 'LineWidth', 5, 'Color', color_order(color_count, :));
FREQ_num_start_index = round((1200 - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;
plot(freq(FREQ_num_start_index, 1) / 1e9,  S11(FREQ_num_start_index, 1), '.', 'Color', color_order(color_count, :), 'Markersize', 36, 'HandleVisibility', 'off');

T2 = csvread('allIMN_1.8G_double28.CSV', 3, 0);  % skips the first three rows of data
freq = T2(:, 1);
S11(:, 2) = T2(:, 2);

color_count = color_count + 1;
S11(:, 2) = smooth(S11(:, 2), smooth_index);
plot(freq / 1e9,  S11(:, 2), '-', 'LineWidth', 5, 'Color', color_order(color_count, :));
FREQ_num_start_index = round((1800 - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;
plot(freq(FREQ_num_start_index, 1) / 1e9,  S11(FREQ_num_start_index, 2), '.', 'Color', color_order(color_count, :), 'Markersize', 36, 'HandleVisibility', 'off');

%T3 = csvread('allIMN_2.4G_single17.CSV', 3, 0);  % skips the first three rows of data
T3 = csvread('new_17.CSV', 3, 0);  % skips the first three rows of data
freq = T3(:, 1);
S11(:, 3) = T3(:, 2);

color_count = color_count + 1;
S11(:, 3) = smooth(S11(:, 3), smooth_index);
plot(freq / 1e9,  S11(:, 3), '-', 'LineWidth', 5, 'Color', color_order(color_count, :));
FREQ_num_start_index = round((2400 - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;
plot(freq(FREQ_num_start_index, 1) / 1e9,  S11(FREQ_num_start_index, 3), '.', 'Color', color_order(color_count, :), 'Markersize', 36, 'HandleVisibility', 'off');




RL = nonzeros(RL);
RL = reshape(RL, FREQ_num, (length(RL) / FREQ_num));
for i = 1:FREQ_num
    RL_mean(i) = mean(RL(i, :));
    RL_var(i) = var(RL(i, :));
end
RL_mean = RL_mean';
RL_var = RL_var';


y_L = yline(-14, '--', '-14 dB', 'LineWidth', 3, 'FontSize', fontsize, 'HandleVisibility', 'off');
y_L.LabelHorizontalAlignment = 'left';


hold on

ylim([-40, 0]);
xlim([0, 3]);

if plot_density
    plot(freq / 1e9, RL_mean, 'Color', [0 0 0], 'LineWidth', 3);
    plot(freq / 1e9, (RL_mean - sqrt(RL_var)), '--', 'Color', [0 0 0], 'LineWidth', 2);
    plot(freq / 1e9, (RL_mean + sqrt(RL_var)), '--', 'Color', [0 0 0], 'LineWidth', 2);
end

grid on
set(gca, 'FontSize', fontsize);
plot_title = 'S11 curves of the #1 FPRFS IMN matched #2 FPRFS 1by2-2-1 IP antenna';
%title(plot_title, 'FontSize', 27);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S11| (dB)', 'FontSize', fontsize);



order = get(gca, 'Children');
legend({'Original load (IP 1\times2-2-1)', 'Other single-stub IMN patterns', 'Double-stub IMN pattern 48', 'Double-stub IMN pattern 28', 'Single-stub IMN pattern 17'}, 'FontSize', 24, 'location', 'southwest');


for i = 1:size(pattern_num_highlight, 1)
    FREQ_num_start_index(i) = round((pattern_num_highlight(i, 1) - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;
    x_opti = xline(pattern_num_highlight(i, 1) / 1e3, '--', [num2str(pattern_num_highlight(i, 1) / 1000),' GHz'], 'LineWidth', 4, 'Color', [1 0 0], 'FontSize', 22, 'fontweight', 'bold', 'HandleVisibility', 'off', 'color', color_order(i, :));
    x_opti.LabelVerticalAlignment = 'bottom';
    x_opti.LabelHorizontalAlignment = 'left';
end

text(1.22, -25, '-24.7 dB', 'fontweight', 'bold', 'Fontsize', 22, 'color', color_order(1, :))
text(1.83, -25.8, '-25.8 dB', 'fontweight', 'bold', 'Fontsize', 22, 'color', color_order(2, :))
text(2.42, -21.5, '-21.5 dB', 'fontweight', 'bold', 'Fontsize', 22, 'color', color_order(3, :))

% plot(freq / 1e9,  S11(:, 19), 'Color', [1 0 0], 'LineWidth', 4);
% plot(freq(FREQ_num_start_index, 1) / 1e9,  S11(FREQ_num_start_index, 19), '.', 'Color', [1 0 0], 'Markersize', 36, 'HandleVisibility', 'off');
% text(freq(FREQ_num_start_index, 1) / 1e9 - 0.36, S11(FREQ_num_start_index, 19) - 1.2, '-25.5dB', 'Fontsize', 20, 'HorizontalAlignment', 'left', 'Color', 'red');
%legend({'S11 of all swept RF surface patterns', 'S11 of self-optimized RF surface pattern'}, 'location', 'northeast', 'FontSize', 20);