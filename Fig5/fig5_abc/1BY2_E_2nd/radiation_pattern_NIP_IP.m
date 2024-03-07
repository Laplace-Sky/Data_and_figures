clear all; close all;
w_window = 660;%1600
h_window = 600;%1000
line_color = [0 0 0; 1 0 0; 0 0 0; 1 0 0];
line_style = {'-', '-', ':', ':'};
line_width = 5;

antenna_type = '1BY2';
xz_plane_plot_enable = 0;  % H
yz_plane_plot_enable = 1;  % E

smooth_plot = 0;
smooth_index = 3;

%---------------------basic settings-------------------%
xz_step = 5;
yz_step = 5;

mirror_pattern = xz_plane_plot_enable;

simulation_plot_enable = 1;

tx_type = '2BY3_PATCH';
tx_type_vertical = '2BY3_PATCH_VERTICAL';


d = 1.06;      %meter
antenna_size = 0.1;        %meter

tar_freq_NIP(1) = 2.1e9; %1.46
tar_freq_NIP(2) = 2.6e9; %2.45
% tar_freq_NIP(3) = 4.2e9; %3.1   
% tar_freq_NIP(4) = 4.3e9; %4.3

tar_freq_IP(1) = 2.25e9; %1.3
tar_freq_IP(2) = 2.72e9; %2.55
% tar_freq_IP(3) = 4.1e9;  %3.15
% tar_freq_IP(4) = 4.3e9;  %4.35


for index = 1:length(tar_freq_NIP)
    lambda_NIP(index) = 3e8 / tar_freq_NIP(index);
    freq_index_NIP(index) = round((tar_freq_NIP(index) - 0.1e9) / ((4.5e9 - 0.1e9) / 1600)) + 1;

    lambda_IP(index) = 3e8 / tar_freq_IP(index);
    freq_index_IP(index) = round((tar_freq_IP(index) - 0.1e9) / ((4.5e9 - 0.1e9) / 1600)) + 1;
end


%%%%%%%%%%%%%plot xz plane pattern%%%%%%%%%%%%%%%%%%
if xz_plane_plot_enable == 1
    for k = 2   % how many frequencies
        
        %calcuate the gain of the tx antenna NIP
        % o degree is face to face
        data_tx = csvread([tx_type, '.csv'], 3, 0);  
        S21_f2f_db(k) = data_tx(freq_index_NIP(k), 2);  % skips the first three rows of data
        Pt = 1;
        Pr_f2f(k) = 10 ^ (S21_f2f_db(k) / 10);
        %Original form
        Ae_f2f(k) = sqrt(Pr_f2f(k) / Pt * (d * lambda_NIP(k))^2);
        G_f2f_NIP(k) = Ae_f2f(k) * 4 * pi / lambda_NIP(k)^2;
        %G_f2f_NIP_db(j) = 10 * log10(G_f2f_NIP(j));


        %calcuate the gain of the tx antenna IP
        % o degree is face to face
        data = csvread([tx_type, '.csv'], 3, 0);  
        S21_f2f_db(k) = data(freq_index_IP(k), 2);  % skips the first three rows of data
        Pt = 1;
        Pr_f2f(k) = 10 ^ (S21_f2f_db(k) / 10);
        %Original form
        Ae_f2f(k) = sqrt(Pr_f2f(k) / Pt * (d * lambda_IP(k))^2);
        G_f2f_IP(k) = Ae_f2f(k) * 4 * pi / lambda_IP(k)^2;
        %G_f2f_IP_db(j) = 10 * log10(G_f2f_IP(j));


        % plot NIP
        i = 0;
        for rotation = 0:xz_step:180
            i = i + 1;
            ang(i) = rotation;

            data = csvread([antenna_type, '_NIP_', int2str(rotation), '.csv'], 3, 0);  

            S21_db(i, k) = data(freq_index_NIP(k), 2);  % skips the first three rows of data
            Pt = 1;
            Pr(i, k) = 10 ^ (S21_db(i, k) / 10);
            %Original form
            G(i, k) = Pr(i, k) / Pt * (4 * pi * d)^2 / (G_f2f_NIP(k) * lambda_NIP(k)^2);
            G_db_NIP(i, k) = 10 * log10(G(i, k));

        end

        %mirror pattern
        if mirror_pattern == 1
            for rotation = 185:xz_step:360
                i = i + 1;
                ang(i) = rotation;
                %Original form
                G(i, k) = G(74 - i, k);
                G_db_NIP(i, k) = G_db_NIP(74 - i, k);
            end
        end

        %plot the xz plane NIP radiation pattern
        figure(k);
        set(gcf,'position',[[200, 200], w_window, h_window]);

        if smooth_plot
            G_db_NIP(:, k) = smooth(G_db_NIP(:, k), smooth_index);    
        end

        polarpattern(ang, G_db_NIP(:, k), 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 10, 'ColorOrder', line_color, 'LineWidth', line_width, 'LineStyle', line_style, ...
            'AngleAtTop', 0, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [-40 0]);
        hold on

        % plot IP
        i = 0;
        for rotation = -180:xz_step:0
            i = i + 1;
            ang(i) = rotation;

            data = csvread([antenna_type, '_IP_', int2str(rotation), '.csv'], 3, 0);  
 
            S21_db(i, k) = data(freq_index_IP(k), 2);  % skips the first three rows of data
            Pt = 1;
            Pr(i, k) = 10 ^ (S21_db(i, k) / 10);
            %Original form
            G(i, k) = Pr(i, k) / Pt * (4 * pi * d)^2 / (G_f2f_IP(k) * lambda_IP(k)^2);
            G_db_IP(i, k) = 10 * log10(G(i, k));
        end

        %mirror pattern
        if mirror_pattern == 1
            for rotation = 5:xz_step:180
                i = i + 1;
                ang(i) = rotation;
                %Original form
                G(i, k) = G(74 - i, k);
                G_db_IP(i, k) = G_db_IP(74 - i, k);

            end
        end

        %plot the xz plane radiation pattern
        figure(k);
        set(gcf,'position',[[200, 200], w_window, h_window]);

        if smooth_plot
            G_db_IP(:, k) = smooth(G_db_IP(:, k), smooth_index);    
        end

        polarpattern(ang, G_db_IP(:, k), 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 10, 'ColorOrder', line_color, 'LineWidth', line_width, 'LineStyle', line_style, ...
            'AngleAtTop', 0, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [-40 0]); 
        hold on

    end
end

%%%%%%%%%%%%%plot yz plane pattern%%%%%%%%%%%%%%%%%%
if yz_plane_plot_enable == 1
    
    for k = 2   % how many frequencies
        
        %calcuate the gain of the tx antenna NIP
        % o degree is face to face
        data_tx = csvread([tx_type_vertical, '.csv'], 3, 0);  
        S21_f2f_db(k) = data_tx(freq_index_NIP(k), 2);  % skips the first three rows of data
        Pt = 1;
        Pr_f2f(k) = 10 ^ (S21_f2f_db(k) / 10);
        %Original form
        Ae_f2f(k) = sqrt(Pr_f2f(k) / Pt * (d * lambda_NIP(k))^2);
        G_f2f_NIP(k) = Ae_f2f(k) * 4 * pi / lambda_NIP(k)^2;
        %G_f2f_NIP_db(j) = 10 * log10(G_f2f_NIP(j));


        %calcuate the gain of the tx antenna IP
        % o degree is face to face
        data = csvread([tx_type_vertical, '.csv'], 3, 0);  
        S21_f2f_db(k) = data(freq_index_IP(k), 2);  % skips the first three rows of data
        Pt = 1;
        Pr_f2f(k) = 10 ^ (S21_f2f_db(k) / 10);
        %Original form
        Ae_f2f(k) = sqrt(Pr_f2f(k) / Pt * (d * lambda_IP(k))^2);
        G_f2f_IP(k) = Ae_f2f(k) * 4 * pi / lambda_IP(k)^2;
        %G_f2f_IP_db(j) = 10 * log10(G_f2f_IP(j));

        % plot NIP
        i = 0;
        for rotation = -180:yz_step:180
            i = i + 1;
            
            if rotation == -180
                ang_vertical(i) = rotation - 90;
            else
                ang_vertical(i) = -rotation - 90;
            end
            
            data = csvread([antenna_type, '_NIP_VERTICAL_', int2str(rotation), '.csv'], 3, 0);  % skips the first three rows of data
            S21_db_vertical(i, k) = data(freq_index_NIP(k), 2);  % skips the first three rows of data
            Pt = 1;
            Pr_vertical(i, k) = 10 ^ (S21_db_vertical(i, k) / 10);
            %Original form
            G_vertical(i, k) = Pr_vertical(i, k) / Pt * (4 * pi * d)^2 / (G_f2f_NIP(k) * lambda_NIP(k)^2);  % used TX Gain from face to face measurement
            G_vertical_db_NIP(i, k) = 10 * log10(G_vertical(i, k));
        end
            
        %plot the xz plane NIP radiation pattern
        figure(k);
        set(gcf,'position',[[200, 200], w_window, h_window]);

        if smooth_plot
            G_vertical_db_NIP(:, k) = smooth(G_vertical_db_NIP(:, k), smooth_index);    
        end

        polarpattern(ang_vertical, G_vertical_db_NIP(:, k), 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 10, 'ColorOrder', line_color, 'LineWidth', line_width, 'LineStyle', line_style, ...
            'AngleAtTop', 0, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [-40 0]);
        hold on
            
        % plot IP
        i = 0;
        for rotation = -180:yz_step:180
            i = i + 1;
            
            if rotation == -180
                ang_vertical(i) = -rotation + 90;
            else
                ang_vertical(i) = rotation + 90;
            end


            data = csvread([antenna_type, '_IP_VERTICAL_', int2str(rotation), '.csv'], 3, 0);  % skips the first three rows of data
            S21_db_vertical(i, k) = data(freq_index_IP(k), 2);  % skips the first three rows of data
            Pt = 1;
            Pr_vertical(i, k) = 10 ^ (S21_db_vertical(i, k) / 10);
            %Original form
            G_vertical(i, k) = Pr_vertical(i, k) / Pt * (4 * pi * d)^2 / (G_f2f_IP(k) * lambda_IP(k)^2);  % used TX Gain from face to face measurement
            G_vertical_db_IP(i, k) = 10 * log10(G_vertical(i, k));
        end
            
        %plot the xz plane NIP radiation pattern
        figure(k);
        set(gcf,'position',[[200, 200], w_window, h_window]);

        if smooth_plot
            G_vertical_db_IP(:, k) = smooth(G_vertical_db_IP(:, k), smooth_index);    
        end

        polarpattern(ang_vertical - 90, G_vertical_db_IP(:, k), 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 10, 'ColorOrder', line_color, 'LineWidth', line_width, 'LineStyle', line_style, ...
            'AngleAtTop', 0, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [-40 0]);
        hold on

    end
end


%%%%%%%%%%% plot simulation result on top%%%%%%%%%%%%%%
if simulation_plot_enable == 1
    for k = 2   % how many frequencies
        %for xz plane
        if xz_plane_plot_enable == 1
            
            data = csvread([antenna_type, '_NIP_freq', int2str(k) ,'_xz' , '.csv'], 1, 0);  % skips the first row of data 

            ang_sim = data(:, 1);
            G_sim = data(:, 2);
            figure(k);
            set(gcf,'color','w');

            polarpattern(ang_sim, G_sim, 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'ColorOrder', line_color, 'LineWidth', line_width,...
                'LineStyle', line_style);
            
            
            data = csvread([antenna_type, '_IP_freq', int2str(k) ,'_xz' , '.csv'], 1, 0);  % skips the first row of data 

            ang_sim = data(:, 1);
            G_sim = data(:, 2);
            figure(k);
            set(gcf,'color','w');
            %subplot(1,2,1);
            polarpattern(ang_sim, G_sim, 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'ColorOrder', line_color, 'LineWidth', line_width,...
                'LineStyle', line_style);
            legend({'Measured NIP', 'Measured IP', 'Simulated NIP', 'Simulatied IP'}, 'FontSize', 12, 'position', [0.08 0.12 0.1 0.05])%[0.58 0.27 0.1 0.05]);
        end
 

        %for yz plane
        if yz_plane_plot_enable == 1
            
            data = csvread([antenna_type, '_NIP_65mm_freq', int2str(k) ,'_yz' , '.csv'], 1, 0);  % skips the first row of data 

            ang_vertical_sim = -data(:, 1);
            G_vertical_sim = data(:, 2);
            figure(k);
            set(gcf,'color','w');

            polarpattern(ang_vertical_sim, G_vertical_sim, 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'ColorOrder', line_color, 'LineWidth', line_width,...
                'LineStyle', line_style);
            
            
            data = csvread([antenna_type, '_IP_65mm_freq', int2str(k) ,'_yz' , '.csv'], 1, 0);  % skips the first row of data 

            ang_vertical_sim = -data(:, 1);
            G_vertical_sim = data(:, 2);
            figure(k);
            set(gcf,'color','w');

            polarpattern(ang_vertical_sim, G_vertical_sim, 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'ColorOrder', line_color, 'LineWidth', line_width,...
                'LineStyle', line_style, 'AngleFontSizeMultiplier', 1.5, 'MagnitudeFontSizeMultiplier', 1.35);
            legend({'Meas: NIP', 'Meas: IP', 'Sim: NIP', 'Sim: IP'}, 'FontSize', 18, 'position', [0.08 0.12 0.1 0.05])%[0.58 0.27 0.1 0.05]);
        end
    end
end
