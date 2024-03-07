clear all; close all
w_window = 1600;
h_window = 800;

fontsize = 27;

plot_density = 0;
patch_length = 0;   % select the cases for patch_length by x antenna patterns; 0 for all cases
plot_LH = ~patch_length;  % plot 850MHz and 4.4GHz
feed_len_sweep = 0;
plot_envelope = ~feed_len_sweep;

feed_len = 0;     % set to 0 for sweeping % to sweep all, set feed_len_sweep to 0 and this to 0
shape_selection = 2;  %0 for w=1 side; 1 for w=2 side; 2 for w=2 mid; 3 for w=3 mid; 4 for w=4 mid; 5 for w=3 side; 6 for w=4 sidemid; 7 for w=4 side

path = pwd;
pattern_folder = dir(path);
filenames = {pattern_folder(:).name};
csvfiles = filenames(endsWith(filenames,'.CSV'));
csvfiles = natsortfiles(filenames(endsWith(filenames,'.CSV')));
MAX_file_num = length(csvfiles);

window_size = 66;
%window_size = 72; %about 100MHz
%window_size = round(-1.07 * MAX_file_num + 93.4);

FREQ_num = 1601;
FREQ_num_start = 850; %MHz
FREQ_num_end = 3850; %MHz
FREQ_num_start_index = round((FREQ_num_start - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;
FREQ_num_end_index = round((FREQ_num_end - 100) / ((4500 - 100) / (FREQ_num - 1))) + 1;

MAX_tens = fix(MAX_file_num / 10);
MAX_ones = rem(MAX_file_num ,10);

freq_min = zeros(FREQ_num, MAX_file_num);
S11 = zeros(FREQ_num, MAX_file_num);
% S11_min = zeros(FREQ_num, MAX_file_num);
%freq_min = zeros(FREQ_num, 1);
%S11 = zeros(FREQ_num, 1);
S11_min = zeros(FREQ_num, 1);

S11_100MHz_max = -100;
S11_4500MHz_max = -100;

freq_bandwidth_L = FREQ_num;
S11_bandwidth_L = 0;
freq_bandwidth_H = 0;
S11_bandwidth_H = 0;

figure
set(gcf,'position',[[200, 200], w_window, h_window]);
Legend = [];
num_pattern = 0;

for i = 1:MAX_file_num
    switch patch_length
        case 0
            condition(i) = 1;
            plot_title = 'FPRFS emulated rectangular patch antennas frequency span:(';
        case 1
            if feed_len == 1
                condition(i) = (mod(i, 10) == 1);
                FREQ_TM10 = 2.1;
                plot_title = 'FPRFS emulated 1-segment long rectangular patch antennas frequency span:(';
            else
                condition(i) = (mod(i, 10) == 1) || (mod(i, 10) == 5) || (mod(i, 10) == 8) || (mod(i, 10) == 0);
                FREQ_TM10 = 2.1;
                plot_title = 'FPRFS emulated 1-segment long rectangular patch antennas frequency span:(';
                if feed_len_sweep
                    condition(i) = ((mod(i, 10) == 1) || (mod(i, 10) == 5) || (mod(i, 10) == 8)) && (fix(i/10) == shape_selection) || (i == 10 * (shape_selection + 1));
                    FREQ_TM10 = 2.12;
                    plot_title = 'FPRFS rectangular emulated patch antennas with varying feedline length frequency span:(';
                end
            end
            
        case 2
            if feed_len == 1
                condition(i) = (mod(i, 10) == 2);
                FREQ_TM10 = 1.42;
                plot_title = 'FPRFS emulated 2-segment long rectangular patch antennas frequency span:(';
            else
                condition(i) = (mod(i, 10) == 2) || (mod(i, 10) == 6) || (mod(i, 10) == 9);
                FREQ_TM10 = 1.42;
                plot_title = 'FPRFS emulated 2-segment long rectangular patch antennas frequency span:(';
                if feed_len_sweep
                    condition(i) = condition(i) && (fix(i/10) == shape_selection);
                    FREQ_TM10 = 1.45;
                    plot_title = 'FPRFS emulated rectangular patch antennas with varying feedline length frequency span:(';
                end
            end
        case 3
            if feed_len == 1
                condition(i) = (mod(i, 10) == 3);
                FREQ_TM10 = 1.12;
                plot_title = 'FPRFS emulated 3-segment long rectangular patch antennas frequency span:(';
            else
                condition(i) = (mod(i, 10) == 3) || (mod(i, 10) == 7);
                FREQ_TM10 = 1.12;
                plot_title = 'FPRFS emulated 3-segment long rectangular patch antennas frequency span:(';
                if feed_len_sweep
                    condition(i) = condition(i) && (fix(i/10) == shape_selection);
                    FREQ_TM10 = 1.12;
                    plot_title = 'FPRFS emulated rectangular patch antennas with varying feedline length frequency span:(';
                end
            end
        case 4
            condition(i) = (mod(i, 10) == 4);
            FREQ_TM10 = 0.95;
            plot_title = 'FPRFS emulated 4-segment long rectangular patch antennas frequency span:(';
            if feed_len_sweep
                condition(i) = condition(i) && (fix(i/10) == shape_selection);
                FREQ_TM10 = 0.95;
                plot_title = 'FPRFS emulated rectangular patch antennas with varying feedline length frequency span:(';
            end
            
    end
    
    if condition(i)
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
                    if(S11(k, i) < S11_min(k))
                        S11_min(k) = S11(k, i);
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
        
        if feed_len_sweep
            plot(freq / 1e9, S11(:, i), 'LineWidth', 4);
            colororder({'#000', '#F00', '#0B0', '#40F'});
            Legend = [Legend; sprintf('Feedline length = %d segment', num_pattern)];
        else
            if num_pattern ~= 8
                plot(freq / 1e9, S11(:, i), ':', 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 2, 'Handlevisibility', 'off');
            else
                plot(freq / 1e9, S11(:, i), ':', 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 2, 'Handlevisibility', 'on');
            end
        end

        hold on
        RL(:, i) = S11(:, i);
    end
end

set(gca, 'Handlevisibility', 'on')

RL = nonzeros(RL);
RL = reshape(RL, FREQ_num, (length(RL) / FREQ_num));
for i = 1:FREQ_num
    RL_mean(i) = mean(RL(i, :));
    RL_var(i) = var(RL(i, :));
end
RL_mean = RL_mean';
RL_var = RL_var';

h = get(gca, 'Children');
set(gca, 'Children', h);

j = 3; %leave index 1 for starting point 0 and index 2 for -10dB bandwidth start
freq_min_plot = zeros(1);
S11_min_plot = zeros(1);
for i = FREQ_num_start_index:FREQ_num_end_index
    if(freq_min(i) == 1)
        freq_min_plot(j) = freq(i);
        S11_min_plot(j) = S11_min(i);
        j = j + 1;
    end       
end
freq_min_plot(1) = 100e6;
S11_min_plot(1) = S11_100MHz_max;
freq_min_plot(2) = freq(freq_bandwidth_L);
S11_min_plot(2) = S11_bandwidth_L;
freq_min_plot(j - 1) = freq(freq_bandwidth_H);
S11_min_plot(j - 1) = S11_bandwidth_H;
freq_min_plot(j) = 4.5e9;
S11_min_plot(j) = S11_4500MHz_max;


freq_min_filtered = zeros(1);
S11_min_filtered = zeros(1);

k = 3;  %leave index 1 for starting point 0 and index 2 for -10dB bandwidth start
flag = 0;  % flag to show whether there is valid min in selected window, otherwise do not increase k

for i = 1:round((freq_bandwidth_H - freq_bandwidth_L) / window_size)
    S11_min_window = 0;
    for j = freq_bandwidth_L + (i - 1) * window_size:freq_bandwidth_L + i * window_size - 1
        if((S11_min(j) < S11_min_window))
            S11_min_filtered(k) = S11_min(j);
            S11_min_window = S11_min(j);
            freq_min_filtered(k) = freq(j);
            flag = 1;
        end
    end
    if(flag == 1)
        k = k + 1;
        flag = 0;
    end
end

freq_min_filtered(1) = 100e6;
S11_min_filtered(1) = S11_100MHz_max;
freq_min_filtered(2) = freq(freq_bandwidth_L);
S11_min_filtered(2) = S11_bandwidth_L;
freq_min_filtered(k) = freq(freq_bandwidth_H);
S11_min_filtered(k) = S11_bandwidth_H;
freq_min_filtered(k + 1) = 4.5e9;
S11_min_filtered(k + 1) = S11_4500MHz_max;


%plot(freq_min_filtered, S11_min_filtered);
%hold on
y_L = yline(-10, '--', '-10 dB', 'LineWidth', 3, 'FontSize', 22, 'HandleVisibility', 'off');
y_L.LabelHorizontalAlignment = 'left';
if plot_LH
    x_L = xline(FREQ_num_start / 1e3, '--', [num2str(FREQ_num_start),' MHz'], 'LineWidth', 3, 'FontSize', 22, 'HandleVisibility', 'off');
    x_H = xline(FREQ_num_end / 1e3, '--', [num2str(FREQ_num_end),' MHz'], 'LineWidth', 3, 'FontSize', 22, 'HandleVisibility', 'off');
    x_L.LabelVerticalAlignment = 'bottom';
    x_H.LabelVerticalAlignment = 'bottom';
    x_L.LabelHorizontalAlignment = 'left';
    x_H.LabelHorizontalAlignment = 'left';
else
    x_TM10 = xline(FREQ_TM10, '--', [num2str(FREQ_TM10),' GHz'], 'Color', [0 0.6 0], 'LineWidth', 3, 'FontSize', 22, 'fontweight', 'bold', 'HandleVisibility', 'off');
    x_TM10.LabelVerticalAlignment = 'bottom';
end

hold on
freq_smooth = 100e6:1000:4.5e9;
if plot_envelope
    plot(freq_smooth / 1e9, pchip(freq_min_filtered ,S11_min_filtered, freq_smooth), '-.r', 'LineWidth', 4);
end
%xlim([0, 4.5e9]);
ylim([-35, 0]);

if plot_density
    plot(freq / 1e9, RL_mean, 'Color', [0 0 0], 'LineWidth', 3);
    plot(freq / 1e9, (RL_mean - sqrt(RL_var)), '--', 'Color', [0 0 0], 'LineWidth', 2, 'HandleVisibility', 'off');
    plot(freq / 1e9, (RL_mean + sqrt(RL_var)), '--', 'Color', [0 0 0], 'LineWidth', 2, 'HandleVisibility', 'off');
end

grid on
set(gca, 'FontSize', fontsize);
%title([plot_title, num2str(size(RL, 2)) ' patterns)'], 'FontSize', 27);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S11| (dB)', 'FontSize', fontsize);

if feed_len_sweep
    legend(Legend, 'Location', 'southeast');
else
    legend({'All FPRFS patch antennas', 'S11 valley envelope'}, 'Location', 'northeast', 'FontSize', fontsize);
end

%plot(freq / 1e9, S11(:, 21), 'Color', 'red', 'LineWidth', 4);