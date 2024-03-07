clear all; close all;
w_window = 600;%1600
h_window = 720;%1000

low_limit = -40;
high_limit = -8;

smooth_plot = 1;
smooth_index = 6;

%---------------------basic settings-------------------%
xz_step = 5;
yz_step = 10;

xz_plane_plot_enable = 1;
yz_plane_plot_enable = 0;
simulation_plot_enable = 0;
identical_tx_rx = 0;  % CHANGE THIS TO BE 1 FOR THE BEST FREQ3 H PLANE RESULT

tx_type = '2BY3_PATCH';

antenna_type = '1BY2';
%shield_type = 'ASYMSHIELD';
shield_side = 'POSSIDE';


d = 1.06;      %meter
antenna_size = 0.1;        %meter

fprintf("\nThe result for antenna type: %s is shown.\n\n", antenna_type);

%finding neibor closest frequency:
% i = 1;
% for freq = 1.5:0.05:2.5
%     tar_freq(i) = freq * 1e9;
%     i = i + 1;
% end

finding_optimal = 0;
freq_order = 5;

 
if finding_optimal
    i = 1;
    for freq = 4.15:0.01:4.2
        tar_freq(i) = freq * 1e9;
        i = i + 1;
    end
else
    tar_freq(1) = 2.1e9;
    %tar_freq(1) = 2.22e9;
    %tar_freq(3) = 2.22e9;
    %tar_freq(4) = 2.45e9;
%     tar_freq(5) = 2.45e9;
end



for j = 1:length(tar_freq)
    lambda(j) = 3e8 / tar_freq(j);
    fraunhofer_distance(j) = 2 * antenna_size^2 / lambda(j);
    G_db_max(j) = -100;
    G_vertical_db_max(j) = -100;
end

%--------------------test condition verification-----------------------
fprintf("Measurement condition:\n", antenna_type);
if(d >= max(fraunhofer_distance))   
	fprintf('All frequencies in Far Field\n\n');
elseif(d <= 0.62 * sqrt(l^3 / max(lambda)))
    fprintf('All frequencies in Reactive Near Field\n\n');
else
    fprintf('Some frequencies in Radiating Near Field\n\n');
end


for index = 1:length(tar_freq)
    freq_index(index) = round((tar_freq(index) - 0.1e9) / ((4.5e9 - 0.1e9) / 1600)) + 1;
end

%line_color ={'#F00','#F80','#FF0','#0B0','#00F','#50F','#A0F'};
line_color = [0 0 0; 1 0 0; 1 0.65 0.65];
line_style = {':', '-', '-', '-', '-', '-', '-'};
line_width = [6; 6: 6; 6; 6; 6; 6];


%%%%%%%%%%%%%plot xz plane pattern%%%%%%%%%%%%%%%%%%
plot_group = [1 6 7]
for k = plot_group
    if (k == 2) || (k == 3)
        angle_stop = 180;
        mirror_pattern = 0;
    else
        angle_stop = 0;
        mirror_pattern = 1;
    end
    
    if xz_plane_plot_enable == 1
        %calcuate the gain of the tx antenna 

        % calcuate the gain of the tx antenna and used for later calculations
        % o degree is face to face
        for j = 1:length(tar_freq)
            data = csvread([tx_type, '.csv'], 3, 0);  
            S21_f2f_db(j) = data(freq_index(j), 2);  % skips the first three rows of data
            Pt = 1;
            Pr_f2f(j) = 10 ^ (S21_f2f_db(j) / 10);
            %Original form
            Ae_f2f(j) = sqrt(Pr_f2f(j) / Pt * (d * lambda(j))^2);
            G_f2f(j) = Ae_f2f(j) * 4 * pi / lambda(j)^2;
            G_f2f_db(j) = 10 * log10(G_f2f(j));
        end


        i = 0;
        for rotation = -180:xz_step:angle_stop
            i = i + 1;
            
            ang(i) = rotation;

            if k == 1  % no shielding
                data = csvread([antenna_type, '_', int2str(rotation), '.csv'], 3, 0);  
                
            elseif k == 2   % diagnalshield
                data = csvread(['DIAGNALSHIELD_POSSIDE_', int2str(rotation), '.csv'], 3, 0); 
                
            elseif k == 3
                data = csvread(['DIAGNALSHIELD_NEGSIDE_', int2str(rotation), '.csv'], 3, 0); 
                
            elseif k == 4   % verticalshield
                data = csvread(['VERTICALSHIELD_POSSIDE_', int2str(rotation), '.csv'], 3, 0); 
                
            elseif k == 5
                data = csvread(['VERTICALSHIELD_NEGSIDE_', int2str(rotation), '.csv'], 3, 0); 
                
            elseif k == 6   % whole shield
                data = csvread(['WHOLESHIELD_POSSIDE_', int2str(rotation), '.csv'], 3, 0); 
                
            elseif k == 7   
                data = csvread(['WHOLESHIELD_NEGSIDE_', int2str(rotation), '.csv'], 3, 0); 
                
            end


            for j = 1:length(tar_freq)  
                S21_db(i, j) = data(freq_index(j), 2);  % skips the first three rows of data
                Pt = 1;
                Pr(i, j) = 10 ^ (S21_db(i, j) / 10);
                %Original form
                G(i, j) = Pr(i, j) / Pt * (4 * pi * d)^2 / (G_f2f(j) * lambda(j)^2);
                G_db(i, j) = 10 * log10(G(i, j));
                G_db_max(j) = max(G_db_max(j), G_db(i, j));
            end
        end

        %mirror pattern
        if mirror_pattern == 1
            for rotation = 5:xz_step:180
                i = i + 1;
                ang(i) = rotation;
                for j = 1:length(tar_freq)
                    %Original form
                    G(i, j) = G(74 - i, j);
                    G_db(i, j) = G_db(74 - i, j);
                end
            end
        end

        % display the TX antenna gain calculated by face to face position
        for j = 1:length(tar_freq)
            fprintf("The TX antenna gain at freq %.2f GHz is: %f\n", tar_freq(j) / 1e9, G_db(1, j))
        end
        fprintf("\n");

        %plot the xz plane radiation pattern
        for j = 1:length(tar_freq)
            figure(j);
            set(gcf,'position',[[200, 200], w_window, h_window]);
            set(gcf,'color','w');
            %subplot(1,2,1);

            if smooth_plot
                G_db(:, j) = smooth(G_db(:, j), smooth_index);    
            end

            polarpattern(ang, G_db(:, j), 'AngleDirection', 'CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'LineWidth', line_width, 'LineStyle', line_style, 'ColorOrder', line_color, ...
                'AngleAtTop', 0, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [low_limit high_limit], 'AngleFontSizeMultiplier', 1.5, 'MagnitudeFontSizeMultiplier', 1.35);
            hold on;
            %polarpattern(ang(37), G_db(37, j), 'Marker', marker, 'ColorOrder', line_color, 'LineWidth', line_width);

            if ~simulation_plot_enable
                if plot_group(2) == 2
                    %legend({'No obstacle', 'Top side diagonal obstacle', 'Bottom side diagonal obstacle'}, 'FontSize', 16, 'position', [0.18 0.14 0.1 0.05])
                elseif plot_group(2) == 4
                    %legend({'No obstacle', 'Top side middle vertical obstacle', 'Bottom side middle vertical obstacle'}, 'FontSize', 20, 'position', [0.45 0.055 0.1 0.05])%[0.58 0.27 0.1 0.05]);
                elseif plot_group(2) == 6
                	%legend({'No obstacle', 'Top side whole surface obstacle', 'Bottom side whole surface obstacle'}, 'FontSize', 20, 'position', [0.45 0.055 0.1 0.05])%[0.58 0.27 0.1 0.05]);
                end
            end

        end



        %%%%%%%%%%% plot simulation result on top%%%%%%%%%%%%%%
        if simulation_plot_enable == 1
            for j = 1:length(tar_freq)
                %for xz plane
                if xz_plane_plot_enable == 1

                    if finding_optimal == 1
                        data = csvread([antenna_type, '_freq', int2str(freq_order) ,'_xz' , '.csv'], 1, 0);  % skips the first row of data 
                    else
                        data = csvread([antenna_type, '_freq', int2str(j) ,'_xz' , '.csv'], 1, 0);  % skips the first row of data 
                    end

                    ang_sim = data(:, 1);
                    G_sim = data(:, 2);

                    for i = 1:90
                        G_sim(i) = G_sim(181 - i);
                    end

                    figure(j);
                    set(gcf,'color','w');
                    %subplot(1,2,1);
                    polarpattern(ang_sim, G_sim, 'AngleDirection','CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'ColorOrder', line_color, 'LineWidth', line_width,...
                        'LineStyle', line_style);
                    %legend({'without IMN (Measured)', 'without IMN (Simulated)', 'with IMN (Measured)', 'with IMN (Simulated)'}, 'FontSize', 18, 'position', [0.25 0.6 0.12 0.06])%[0.58 0.27 0.1 0.05]);

                end
            end
        end
    end
end

