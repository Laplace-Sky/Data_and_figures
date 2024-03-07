clear all; close all;
w_window = 500;%1600
h_window = 600;%1000


smooth_plot = 1;
smooth_index = 6;
colororder = [0 0 0; 0 0.62 0; 0.6 0.95 0; 0.90 0.90 0.08];
%[0 0 0; 1 0 0; 0.1 0.75 0; 0.3 0.7 1; 1 0.68 0];

%---------------------basic settings-------------------%
xz_step = 5;


tx_type = '2BY3_PATCH';


freq_optimize = '2.45G';


d_patch = 1.06;      %meter
antenna_size = 0.1;        %meter


tar_freq(1) = 2.1e9;
tar_freq(2) = 2.17e9;
tar_freq(3) = 2.22e9;
tar_freq(4) = 2.45e9;

num_pattern = [3 3 3 3];
sym = [1 0 1 1;
       1 0 1 1;
       1 0 1 1;
       1 1 1 0];

for j = 1:length(tar_freq)
    lambda(j) = 3e8 / tar_freq(j);
    fraunhofer_distance(j) = 2 * antenna_size^2 / lambda(j);
    G_db_max(j) = -100;
    G_vertical_db_max(j) = -100;
end



for index = 1:length(tar_freq)
    freq_index(index) = round((tar_freq(index) - 0.1e9) / ((4.5e9 - 0.1e9) / 1600)) + 1;
end

line_color = [0 0 0; colororder];
line_style = {':', '-', '-', '-', '-', '-', '-', '-', '-'};%{'-', '-', ':', ':', '-', '-', ':', ':'};
line_width = [5.5; 5.5; 5.5; 5.5; 5.5];%[3; 5; 4; 5; 3; 5; 4; 5];
marker = {};%{'none', '*', 'none', '*', 'none', '*', 'none', '*'};

 %calcuate the gain of the tx antenna 

% calcuate the gain of the tx antenna and used for later calculations
% o degree is face to face
for j = 1:length(tar_freq)
    data = csvread([tx_type, '.csv'], 3, 0);  
    S21_f2f_db(j) = data(freq_index(j), 2);  % skips the first three rows of data
    Pt = 1;
    Pr_f2f(j) = 10 ^ (S21_f2f_db(j) / 10);
    %Original form
    Ae_f2f(j) = sqrt(Pr_f2f(j) / Pt * (d_patch * lambda(j))^2);
    G_f2f(j) = Ae_f2f(j) * 4 * pi / lambda(j)^2;
    G_f2f_db(j) = 10 * log10(G_f2f(j));
end

if strcmp(freq_optimize, '2.1G')
    sequence = 1;
    
    low_limit = -15;
    high_limit = 0;
    
elseif strcmp(freq_optimize, '2.17G')
    sequence = 2;
    
    low_limit = -15;
    high_limit = 0;
    
elseif strcmp(freq_optimize, '2.22G')
    sequence = 3;
    
    low_limit = -15;
    high_limit = 0;
    
elseif strcmp(freq_optimize, '2.45G')
    sequence = 4;
    
    low_limit = -25;
    high_limit = 0;
    
end
    
for k = 0:num_pattern(sequence) 
    

    if sym(sequence, k + 1)
        angle_stop = 0;
        mirror_pattern = 1;
    elseif sym(sequence, k + 1) == 0
        angle_stop = 180;
        mirror_pattern = 0;
    end

    
    i = 0;
    for rotation = -180:xz_step:angle_stop
        i = i + 1;
        
        ang(i) = rotation;
        
        if sequence == 1
            if k == 0
                data = csvread(['NOPATTERN', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 1
                data = csvread(['2BY3-3-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 2
                data = csvread(['2BY2-2-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 3
                data = csvread(['1BY4-3-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            end
        elseif sequence == 2
            if k == 0
                data = csvread(['NOPATTERN', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 1
                data = csvread(['2BY3-3-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 2
                data = csvread(['2BY2-2-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 3
                data = csvread(['1BY4-3-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            end
        elseif sequence == 3
            if k == 0
                data = csvread(['NOPATTERN', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 1
                data = csvread(['2BY3-3-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 2
                data = csvread(['2BY2-2-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 3
                data = csvread(['1BY4-3-1', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            end
        elseif sequence == 4
            if k == 0
                data = csvread(['NOPATTERN', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 1
                data = csvread(['1BY2-2-3', '_', int2str(rotation), '.csv'], 3, 0);  
                d = 1.06;

            elseif k == 2
                data = csvread(['1BY4-3-1', '_', int2str(rotation), '.csv'], 3, 0); 
                d = 1.06;

            elseif k == 3
                data = csvread(['1BY2-3-2', '_', int2str(rotation), '.csv'], 3, 0);   
                d = 1.06; 

            end
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
        rotate_start = xz_step;
        for rotation = rotate_start:xz_step:180
            i = i + 1;
            ang(i) = rotation;
            for j = 1:length(tar_freq)
                %Original form
                if xz_step == 5
                    G(i, j) = G(74 - i, j);
                    G_db(i, j) = G_db(74 - i, j);
                elseif xz_step == 10
                    G(i, j) = G(38 - i, j);
                    G_db(i, j) = G_db(38 - i, j);
                end

            end
        end
    end

    % display the TX antenna gain calculated by face to face position
    for j = 1:length(tar_freq)
        fprintf("The TX antenna gain at freq %.2f GHz is: %f\n", tar_freq(j) / 1e9, G_db(1, j))
    end
    fprintf("\n");
    
    
    % start plotting
    for j = sequence:sequence
        figure(j);
        set(gcf,'position',[[200, 200], w_window, h_window]);
        set(gcf,'color','w');

        if smooth_plot
            G_db(:, j) = smooth(G_db(:, j), smooth_index);    
        end

        
        p = polarpattern(ang, G_db(:, j), 'AngleDirection', 'CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'ColorOrder', line_color, 'LineWidth', line_width, 'LineStyle', line_style, ...
            'AngleAtTop', 0, ...
            'MagnitudeAxisAngle', 0, 'MagnitudeLim', [low_limit high_limit], ...
            'ColorOrder', colororder, 'AngleFontSizeMultiplier', 2, 'MagnitudeFontSizeMultiplier', 2, 'AngleTickLabelFormat', '180');%'TitleTop', sprintf('Optimized radiation patterns at %.2fGHz',
                                                                                                        %tar_freq(j)/1e9), 'TitleTopOffset', 0.45, 
        hold on;
        


        if sequence == 1
            %legend({'No Pattern', 'Patch Pattern 1BY4-3-3', 'Patch Pattern 3BY3-3-1', 'Patch Pattern 2BY2-2-1'}, 'FontSize', 17, 'position', [0.75 0.1 0.1 0.05])%[0.58 0.27 0.1 0.05]);
        elseif sequence == 2
            %legend({'No Pattern', 'Patch Pattern 2\times3-3-1', 'Patch Pattern 2\times2-2-1', 'Patch Pattern 1\times4-3-1'}, 'FontSize', 17, 'position', [0.75 0.08 0.1 0.05])%[0.58 0.27 0.1 0.05]);
        elseif sequence == 3
            %legend({'No Pattern', 'Patch Pattern 1BY4-3-3', 'Patch Pattern 1BY3-3-3', 'Patch Pattern 1BY2-3-3', 'Patch Pattern 1BY4-3-1'}, 'FontSize', 17, 'position', [0.8 0.1 0.1 0.05])%[0.58 0.27 0.1 0.05]);
        elseif sequence == 4
            %legend({'No Pattern', 'Patch Pattern 1\times2-2-3', 'Patch Pattern 1\times4-3-1', 'Patch Pattern 1\times2-3-2'}, 'FontSize', 22, 'position', [0.75 0.08 0.1 0.05])%[0.58 0.27 0.1 0.05]);
        end


        if sequence == 1
            if k == 1
                addCursor(p, 0, k + 1);

            elseif k == 2
                addCursor(p, -30, k + 1);
                addCursor(p, -60, k + 1); 
                addCursor(p, -120, k + 1);

            elseif k == 3
                addCursor(p, -90, k + 1);
                addCursor(p, -150, k + 1);
                addCursor(p, -180, k + 1);
            end

        elseif sequence == 2
            if k == 1
                addCursor(p, 0, k + 1);
                addCursor(p, -30, k + 1);

            elseif k == 2
                addCursor(p, -60, k + 1);
                addCursor(p, -150, k + 1);
                addCursor(p, -180, k + 1);

            elseif k == 3
                addCursor(p, -90, k + 1);
                addCursor(p, -120, k + 1);

            end

        elseif sequence == 3
            if k == 1
                addCursor(p, 0, k + 1);

            elseif k == 2
                addCursor(p, -30, k + 1);

            elseif k == 3
                addCursor(p, -60, k + 1);
                addCursor(p, -90, k + 1);

            elseif k == 4
                addCursor(p, -120, k + 1);
                addCursor(p, -150, k + 1);
                addCursor(p, -180, k + 1);

            end

        elseif sequence == 4
            if k == 1
                addCursor(p, 0, k + 1);
                addCursor(p, -30, k + 1);

            elseif k == 2
                addCursor(p, -60, k + 1);
                addCursor(p, -150, k + 1);
                addCursor(p, -180, k + 1);

            elseif k == 3
                addCursor(p, -90, k + 1);
                addCursor(p, -120, k + 1);

            end
        end

    end
    
end

