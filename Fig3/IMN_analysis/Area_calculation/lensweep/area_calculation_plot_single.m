clear all
close all

IMN_stub_setting = 0;    % 0 for both one and two stub cases; 1 for single stub only; 2 for two stub only;
filled_plot_show = 0;
enable_plot_save = 1;

num_H = 6;
num_V = 5;

f = 2.45; %GHz
k = 0.2;
% len = 10;  %mm
% len_start = 5;
% len_step = 5;
% len_stop = 20;

scale = 1;      %determines the resolution
window_size = 1050;      % this decides the png picture resolutions, higher the number, higher the percentage precision but longer calculation time
%---------------------------setting for plots----------------
if enable_plot_save
    Highlight_outline = 1;
    save_pdf_enable = 0;
    Cartesian_only = 0;
    line_width = 3;
    marker = 'o';
    markerSize = 3;
    fontSize = 18;

    window_size_x = scale*window_size / 1.3125;
    window_size_y = scale*window_size;
    color_single = [0 0.4 1];   %blue
    color_double = [0.8 0.9 1]; %light blue  [0.7 0.85 1]
    color_outline = [1 0 0];     %red
    color_covercircle = [0 0 0]; %black

    if IMN_stub_setting == 1
        colororder = zeros((num_H - 1) * num_V + 2, 3);  
        for p = 1:(num_H - 1) * num_V + 1
            colororder(p, :) = color_single;
        end
        colororder((num_H - 1) * num_V + 2, :) = color_covercircle;
    elseif IMN_stub_setting == 2
        colororder = zeros(nchoosek(num_H - 1, 2) * num_V * num_V + 1, 3);
        for p = 1:nchoosek(num_H - 1, 2) * num_V * num_V
            colororder(p, :) = color_double;
        end
        colororder(nchoosek(num_H - 1, 2) * num_V * num_V + 1, :) = color_covercircle;
    else
        colororder = zeros((num_H - 1) * num_V + nchoosek(num_H - 1, 2) * num_V * num_V + 2, 3);  
        for p = 1:nchoosek(num_H - 1, 2) * num_V * num_V
            colororder(p, :) = color_double;
        end
        for p = nchoosek(num_H - 1, 2) * num_V * num_V + 1:(num_H - 1) * num_V + nchoosek(num_H - 1, 2) * num_V * num_V + 1
            colororder(p, :) = color_single;
        end
        colororder((num_H - 1) * num_V + nchoosek(num_H - 1, 2) * num_V * num_V + 2, :) = color_covercircle;
    end
end
%-------------------------------------------------%

Z0 = 50;
resolution = 100;       % resolution of circle (2*pi/100)
i = sqrt(-1);

%------------plot just the Smith chart outline---------------%
%black is represented by 0 and white is represented by 1
figure('Name', 'Smith chart outline only');
set(gcf,'position',[1100,50,scale*window_size,scale*window_size]);                             % the graph setting should be maintained the same to get same output png file resolutions
smithplot(0, 'GridVisible', 0, 'ColorOrder', [0 0 0], 'LineWidth', 0.1, 'ArcTickLabelVisible', 0, 'CircleTickLabelVisible', 0); % the Smith chart circle (used to be minused later)
saveas(gcf, 'Smith_circle.png')
I = imread('Smith_circle.png');
Smith_circle = im2bw(I, 0.9);
Smith_circle_filled = ones(size(Smith_circle));                   %containing zeros as overall smith chart area

[B0,L,N0,A] = bwboundaries(Smith_circle, 8, 'holes');
boundary = B0{length(B0)};   
boundary_smith_inner = B0{2}; 
%plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)

bound_circle = cell2mat(B0(length(B0), 1));
x_min_Smithcircle = min(bound_circle(:,2));
x_max_Smithcircle = max(bound_circle(:,2));
y_min_Smithcircle = min(bound_circle(:,1));
y_max_Smithcircle = max(bound_circle(:,1));
y_range_Smithcircle = y_max_Smithcircle - y_min_Smithcircle;

for q = x_min_Smithcircle:x_max_Smithcircle
    for p = y_min_Smithcircle:1:(y_min_Smithcircle + ceil(y_range_Smithcircle/2))
        if(Smith_circle(p, q) == 0) % y first and then x
            y_min_Smithcircle_l = p;
            break
        end
    end
    for p = y_max_Smithcircle:-1:(y_max_Smithcircle - ceil(y_range_Smithcircle/2))
        if(Smith_circle(p, q) == 0) % y first and then x
            y_max_Smithcircle_l = p;
            break
        end
    end
    for p = y_min_Smithcircle_l:y_max_Smithcircle_l
        Smith_circle_filled(p, q) = 0;
    end
end
%imshow(Smith_circle_filled)
close

Smith_area = sum(~Smith_circle_filled(:))
num_file = 0;


for len = 45   %len_start:len_step:len_stop            % len unit is mm!
    num_file = num_file + 1;
    BW_all_circles = ones(size(Smith_circle));
    BW_single_circles = ones(size(Smith_circle));
    num_unshown = 0;     %% too small circles will not be shown and will cause glitches
    seg_len(num_file) = len;
    fprintf('Length: %dmm\n', seg_len(num_file));

    if (IMN_stub_setting == 0) || (IMN_stub_setting == 2)
        %------------Data parsing from Mathematica output files (two stub case)---------------%
        num_case = nchoosek(num_H - 1, 2) * num_V * num_V;

        filename = sprintf('two stub_k=%.2f_%dmm_%.2fG.txt', k, len, f);
        %filename = sprintf('test_two stub.txt');
        fid = fopen(filename);
        data = textscan(fid, '%s','Delimiter', '&&');

        fclose(fid);
        center = zeros(num_case,2);
        r = zeros(num_case,1);
        num_seg1 = zeros(num_case,1);
        num_seg2 = zeros(num_case,1);
        num_seg3 = zeros(num_case,1);
        num_seg4 = zeros(num_case,1);
        num_seg5 = zeros(num_case,1);
        num_seg6 = zeros(num_case,1);

        q = 1;

        for j = 1:length(data{1,1})
            if(mod(j,16) == 11)             %%parsing the x y coordinates of the circle center
                seg = split(string(data{1,1}(j)), ' ');

                seg1 = erase(seg(3,1), ')');
                seg1 = split(seg1(1,1), '*^');
                if(length(seg1) ~= 1)
                    num_seg1(q) = str2double(seg1(1,1)) * 10^str2double(seg1(2,1));
                else
                    num_seg1(q) = str2double(seg1(1,1));
                end
                center(q,2) = num_seg1(q);      %%y coordinates of all circle centers

                seg2 = erase(erase(seg(5,1), '(Inequality['), ',');
                seg2 = split(seg2(1,1), '*^');
                if(length(seg2) ~= 1)
                    num_seg2(q) = str2double(seg2(1,1)) * 10^str2double(seg2(2,1));
                else
                    num_seg2(q) = str2double(seg2(1,1));
                end
                seg3 = erase(seg(9,1), ']');
                seg3 = split(seg3(1,1), '*^');
                if(length(seg3) ~= 1)
                    num_seg3(q) = str2double(seg3(1,1)) * 10^str2double(seg3(2,1));
                else
                    num_seg3(q) = str2double(seg3(1,1));
                end
                center(q,1) = (num_seg2(q) + num_seg3(q)) / 2;   %%x coordinates of all circle centers
            end

            if(mod(j,16) == 13)                          %%parsing the radius r of the circle
                seg4 = split(string(data{1,1}(j)), ' ');
                seg4 = split(seg4(3,1), '*Sqrt[');
                seg5 = split(seg4(1,1), '*^');
                if(length(seg5) ~= 1)
                    num_seg5(q) = str2double(seg5(1,1)) * 10^str2double(seg5(2,1));
                else
                    num_seg5(q) = str2double(seg5(1,1));
                end
                seg6 = split(seg4(2,1), '*^');
                if(length(seg6) ~= 1)
                    num_seg6(q) = str2double(seg6(1,1)) * 10^str2double(seg6(2,1));
                else
                    num_seg6(q) = str2double(seg6(1,1));
                end
                r(q) = sqrt(num_seg5(q)^2 * num_seg6(q) + center(q,1)^2);

        %         viscircles([center(q,1) center(q,2)], r(q));        %% plot the circles one by one
        %         hold on

                q = q + 1; 
            end     
        end

        center;
        r;

%         % plot on Cartesion coordinate
%         figure('Name', 'Cartesion expression');
%         set(gcf,'position',[200,50,600,scale*window_size]);
        circle_x = zeros(num_case, resolution + 1);
        circle_y = zeros(num_case, resolution + 1);
        Z = zeros(num_case, resolution + 1);
        gamma = zeros(num_case, resolution + 1);
% 
% 
        for q = 1:num_case
            rad = r(q,1);
            center_x = center(q,1);
            center_y = center(q,2);
            for p = 1:(resolution + 1)
                circle_x(q,p) = rad * cos((p - 1) * 2*pi/resolution) + center_x;
                circle_y(q,p) = rad * sin((p - 1) * 2*pi/resolution) + center_y;
                Z(q,p) = circle_x(q,p) + i * circle_y(q,p);
                gamma(q,p) = z2gamma(Z(q,p), Z0);
            end
%             plot(circle_x(q,:), circle_y(q,:));               %% plot the circles one by one
%             hold on
        end
% 
%         daspect([1 1 1])
%         xlabel('Resistance R');
%         ylabel('Reactance X');
         close
        



        %-------------plot on Smith Chart for area calculation (two stub case)------------------%
        figure('Name', 'Individual circles');

        for q = 1:num_case
            set(gcf,'position',[1100,50,scale*window_size,scale*window_size]);
            smithplot(gamma(q,:), 'GridVisible', 0, 'ColorOrder', [0 0 0], 'LineWidth', 0.1, 'ArcTickLabelVisible', 0, 'CircleTickLabelVisible', 0);
            saveas(gcf, 'individual_circles.png');

            I = imread('individual_circles.png');
            single_circle = im2bw(I,0.9);
            BW = ~xor(single_circle, Smith_circle);        % this is to cancel the Smith chart outline

            [B,L,N,A] = bwboundaries(BW, 8, 'holes');
            boundary = B{length(B)};   
            %plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)

            bound_circle = cell2mat(B(length(B), 1));
            if (bound_circle(1, 1) == 1)      % this means only the window outline square is detected as boundary, which means there is no circle shown
                num_unshown = num_unshown + 1;
                continue
            end
            x_min = min(bound_circle(:,2));
            x_max = max(bound_circle(:,2));
            y_min = min(bound_circle(:,1));
            y_max = max(bound_circle(:,1));
            y_range = y_max - y_min;

            % fill each single circle
            for s = x_min:1:x_max
                for p = y_min:1:y_max
                    if(BW(p, s) == 0) % y first and then x
                        y_min_l = p;
                        break
                    end
                end
                for p = y_max:-1:y_min
                    if(BW(p, s) == 0) % y first and then x
                        y_max_l = p;
                        break
                    end
                end
                for p = y_min_l:y_max_l
                    BW(p, s) = 0;
                end
            end
            
            BW_all_circles = BW_all_circles & BW;

        end
        close

        IMN_area(num_file) = sum(~BW_all_circles(:));
        area_percent(num_file) = IMN_area(num_file) / Smith_area;

        num_unshown;

        % to plot the filled IMN circles together with the Smith chart outline
        if filled_plot_show == 1
            figure('Name', 'All circles filled', 'Visible', 'on');
            BW_all_circles = BW_all_circles & Smith_circle;
            imshow(BW_all_circles)
        end

        % plot on Smith Chart
    %     figure(1);
    %     set(gcf,'position',[900,50,scale*window_size,scale*window_size]);
    %     for q = 1:num_case
    %         smithplot(gamma(q,:));             %% plot the circles one by one
    %         hold on
    %     end
    
        if enable_plot_save
            figure(5);
            set(gcf,'position',[0,0,scale * window_size_x,scale * window_size_y]);

            for q = 1:num_case
                plot(circle_x(q,:), circle_y(q,:), 'LineWidth', line_width, 'Color', color_double);               %% plot the circles one by one
                hold on
            end
            XL = get(gca, 'XLim');
            YL = get(gca, 'YLim');

            %clear text for output png to find boundaries
            set(gca,'visible','off')
            
            if len == 14
                xlim([0 2200])
                xticks([0 500 1000 1500 2000])
                yticks([-2000 -1500 -1000 -500 0 500 1000])
                set(gca, 'fontsize', 18)
            else
                set(gca,'XTick',[], 'YTick', []);
            end

            daspect([1 1 1])
            xlabel('Resistance R');
            ylabel('Reactance X');
            
            if save_pdf_enable
                ax = gca;
                filename = sprintf('Cartesian_two stub_k=%.2f_%dmm_%.2fG_numV=5.pdf', k, len, f);
                if IMN_stub_setting == 2
                    %to finish if needed   
                    exportgraphics(ax,filename,'ContentType','vector');
                end
            end

            if ~Cartesian_only
                % plot on Smith Chart
                figure(6);
                set(gcf, 'Visible', 'off');
                set(gcf,'position',[0,0,scale*window_size,scale*window_size]);
                smithplot(0, 'GridVisible', 0, 'ColorOrder', colororder, 'LineWidth', line_width, 'ArcTickLabelVisible', 0, 'CircleTickLabelVisible', 0); % the Smith chart circle (used to be minused later)
                for q = 1:num_case
                    smithplot(gamma(q,:), 'LineWidth', line_width, 'ColorOrder', colororder);             %% plot the circles one by one
                    hold on
                end

                smithplot(0, 'GridVisible', 1, 'ColorOrder', colororder, 'LineWidth', line_width, 'ArcTickLabelVisible', 1, 'CircleTickLabelVisible', 1); % the Smith chart circle (used to be minused later)

                if save_pdf_enable
                    ax = gca;
                    filename = sprintf('Smith_two stub_k=%.2f_%dmm_%.2fG_numV=5.pdf', k, len, f);
                    if MN_stub_setting == 2
                        exportgraphics(ax,filename,'ContentType','vector');
                    end
                end
            end
        end
    end
    
    
    if (IMN_stub_setting == 0) || (IMN_stub_setting == 1)
        %------------Data parsing from Mathematica output files (single stub case)---------------%
        num_case = (num_H - 1) * num_V;
        filename = sprintf('single stub_k=%.2f_%dmm_%.2fG.txt', k, len, f);
        fid = fopen(filename);
        data = textscan(fid, '%s','Delimiter', '&&');

        fclose(fid);
        center = zeros(num_case,2);
        r = zeros(num_case,1);
        num_seg1 = zeros(num_case,1);
        num_seg2 = zeros(num_case,1);
        num_seg3 = zeros(num_case,1);
        num_seg4 = zeros(num_case,1);
        num_seg5 = zeros(num_case,1);
        num_seg6 = zeros(num_case,1);

        q = 1;

        for j = 1:length(data{1,1})
            if(mod(j,12) == 7)             %%parsing the x y coordinates of the circle center
                seg = split(string(data{1,1}(j)), ' ');

                seg1 = erase(seg(3,1), ')');
                seg1 = split(seg1(1,1), '*^');
                if(length(seg1) ~= 1)
                    num_seg1(q) = str2double(seg1(1,1)) * 10^str2double(seg1(2,1));
                else
                    num_seg1(q) = str2double(seg1(1,1));
                end
                center(q,2) = num_seg1(q);      %%y coordinates of all circle centers

                seg2 = erase(erase(seg(5,1), '(Inequality['), ',');
                seg2 = split(seg2(1,1), '*^');
                if(length(seg2) ~= 1)
                    num_seg2(q) = str2double(seg2(1,1)) * 10^str2double(seg2(2,1));
                else
                    num_seg2(q) = str2double(seg2(1,1));
                end
                seg3 = erase(seg(9,1), ']');
                seg3 = split(seg3(1,1), '*^');
                if(length(seg3) ~= 1)
                    num_seg3(q) = str2double(seg3(1,1)) * 10^str2double(seg3(2,1));
                else
                    num_seg3(q) = str2double(seg3(1,1));
                end
                center(q,1) = (num_seg2(q) + num_seg3(q)) / 2;   %%x coordinates of all circle centers
            end

            if(mod(j,12) == 9)                          %%parsing the radius r of the circle
                seg4 = split(string(data{1,1}(j)), ' ');
                seg4 = split(seg4(3,1), '*Sqrt[');
                seg5 = split(seg4(1,1), '*^');
                if(length(seg5) ~= 1)
                    num_seg5(q) = str2double(seg5(1,1)) * 10^str2double(seg5(2,1));
                else
                    num_seg5(q) = str2double(seg5(1,1));
                end
                seg6 = split(seg4(2,1), '*^');
                if(length(seg6) ~= 1)
                    num_seg6(q) = str2double(seg6(1,1)) * 10^str2double(seg6(2,1));
                else
                    num_seg6(q) = str2double(seg6(1,1));
                end
                r(q) = sqrt(num_seg5(q)^2 * num_seg6(q) + center(q,1)^2);

        %         viscircles([center(q,1) center(q,2)], r(q));        %% plot the circles one by one
        %         hold on

                q = q + 1; 
            end
        end

        center;
        r;
        
        % plot the concentric circle with k radius (main line only case)
        VSWR = (1 + k) / (1 - k);
        r0 = Z0 * (VSWR - 1 / VSWR) / 2;
        center0 = [(Z0 * (VSWR + 1 / VSWR) / 2) 0];

        % plot on Cartesion coordinate
        figure('Name', 'Cartesion expression');
        set(gcf,'position',[200,50,scale*window_size_x,scale*window_size_y]);
        circle_x = zeros(num_case, resolution + 1);
        circle_y = zeros(num_case, resolution + 1);
        Z = zeros(num_case, resolution + 1);
        gamma = zeros(num_case, resolution + 1);

        for q = 1:num_case + 1     %% extra case is for the k concentric circle
            if q == num_case + 1
                rad = r0;
                center_x = center0(1);
                center_y = center0(2);
                for p = 1:(resolution + 1)
                    circle_x(q,p) = rad * cos((p - 1) * 2*pi/resolution) + center_x;
                    circle_y(q,p) = rad * sin((p - 1) * 2*pi/resolution) + center_y;
                    Z(q,p) = circle_x(q,p) + i * circle_y(q,p);
                    gamma(q,p) = z2gamma(Z(q,p), Z0);
                end
            else
                rad = r(q,1);
                center_x = center(q,1);
                center_y = center(q,2);
                for p = 1:(resolution + 1)
                    circle_x(q,p) = rad * cos((p - 1) * 2*pi/resolution) + center_x;
                    circle_y(q,p) = rad * sin((p - 1) * 2*pi/resolution) + center_y;
                    Z(q,p) = circle_x(q,p) + i * circle_y(q,p);
                    gamma(q,p) = z2gamma(Z(q,p), Z0);
                end
            end
%             plot(circle_x(q,:), circle_y(q,:));               %% plot the circles one by one
%             hold on
        end

%         daspect([1 1 1])
%         xlabel('Resistance R');
%         ylabel('Reactance X');
         close


        %-------------plot on Smith Chart for area calculation (single stub case)------------------%
        figure('Name', 'Individual circles');

        for q = 1:num_case + 1         %% one more case for k concentric circle
            set(gcf,'position',[1100,50,scale*window_size,scale*window_size]);
            smithplot(gamma(q,:), 'GridVisible', 0, 'ColorOrder', [0 0 0], 'LineWidth', 0.1, 'ArcTickLabelVisible', 0, 'CircleTickLabelVisible', 0);
            saveas(gcf, 'individual_circles.png');

            I = imread('individual_circles.png');
            single_circle = im2bw(I,0.9);
            BW = ~xor(single_circle, Smith_circle);        % this is to cancel the Smith chart outline

            [B,L,N,A] = bwboundaries(BW, 8, 'holes');
            boundary = B{length(B)};   
            %plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)

            bound_circle = cell2mat(B(length(B), 1));
            if (bound_circle(1, 1) == 1)      % this means only the window outline square is detected as boundary, which means there is no circle shown
                num_unshown = num_unshown + 1;
                continue
            end
            x_min = min(bound_circle(:,2));
            x_max = max(bound_circle(:,2));
            y_min = min(bound_circle(:,1));
            y_max = max(bound_circle(:,1));
            y_range = y_max - y_min;

            for s = x_min:x_max
                for p = y_min:1:(y_min + ceil(y_range/2) + 1)
                    if(BW(p, s) == 0) % y first and then x
                        y_min_l = p;
                        break
                    end
                end
                for p = y_max:-1:(y_max - ceil(y_range/2) - 1)
                    if(BW(p, s) == 0) % y first and then x
                        y_max_l = p;
                        break
                    end
                end
                for p = y_min_l:y_max_l
                    BW(p, s) = 0;
                end
            end

            BW_all_circles = BW_all_circles & BW;
            BW_single_circles = BW_single_circles & BW;

        end
        close
        
        IMN_area(num_file) = sum(~BW_all_circles(:));
        area_percent(num_file) = IMN_area(num_file) / Smith_area;
        area_percent_singlestub(num_file) = sum(~BW_single_circles(:)) / Smith_area;
        
        fprintf('Single stub matching cover circle area percent: %f\n', area_percent(num_file));
        
        BW_all_circles_with_Smith = BW_all_circles & Smith_circle;
        filename_savefig_fill = sprintf('Filled_k=%.2f_%dmm_%.2fG_numV=5.png', k, len, f);
        imwrite(BW_all_circles_with_Smith, filename_savefig_fill, 'png');
        % to plot the filled IMN circles together with the Smith chart outline
        if filled_plot_show
            figure('Name', 'All circles filled', 'Visible', 'on');
            set(gcf,'position',[1100,50,scale*window_size,scale*window_size]);
            imshow(BW_all_circles_with_Smith);
        end
        

        
        
        
        % plot on Smith Chart
    %     figure(1);
    %     set(gcf,'position',[900,50,scale*window_size,scale*window_size]);
    %     for q = 1:num_case
    %         smithplot(gamma(q,:));             %% plot the circles one by one
    %         hold on
    %     end
    
        % these are used to calculate the largest circle fitting the IMN area
        Smithcircle_center_pixel = [length(BW_all_circles)/2 length(BW_all_circles)/2];
        r_min(num_file) = y_range_Smithcircle / 2;

        %this is to find the cover circle for ploting
        for p = x_min_Smithcircle:x_max_Smithcircle
             for q = y_min_Smithcircle:y_max_Smithcircle
                 if BW_all_circles(p, q) == 1
                     cover_circle_r = sqrt((p - Smithcircle_center_pixel(1))^2 + (q - Smithcircle_center_pixel(2))^2);
                     if cover_circle_r < r_min(num_file)
                     	point_x(num_file) = p;
	                 	point_y(num_file) = q;
                    	r_min(num_file) = cover_circle_r;
                     end
                 end
             end
        end
         cover_circle_area_percent(num_file) = pi * r_min(num_file)^2 / Smith_area;
 
         r_covercircle = sqrt(cover_circle_area_percent(num_file));
         VSWR = (1 + r_covercircle) / (1 - r_covercircle);
         r_covercircle = Z0 * (VSWR - 1 / VSWR) / 2;
         center_covercircle = [(Z0 * (VSWR + 1 / VSWR) / 2) 0];
         
         for p = 1:(2 * resolution + 1)
            circle_covercircle_x(p) = r_covercircle * cos((p - 1) * 2*pi/(2 * resolution)) + center_covercircle(1);
            circle_covercircle_y(p) = r_covercircle * sin((p - 1) * 2*pi/(2 * resolution)) + center_covercircle(2);
            Z_covercircle(p) = circle_covercircle_x(p) + i * circle_covercircle_y(p);
            gamma_covercircle(p) = z2gamma(Z_covercircle(p), Z0);
        end
    
        if enable_plot_save
            figure(5);
            set(gcf,'position',[0,0,scale * window_size_x,scale * window_size_y]);  
            
            for q = 1:num_case + 1
                plot(circle_x(q,:), circle_y(q,:), 'LineWidth', line_width, 'Color', color_single);               %% plot the circles one by one
                hold on
            end
            XL1 = get(gca, 'XLim');
            YL1 = get(gca, 'YLim');
            daspect([1 1 1])
            
            xlim([min(XL(1), XL1(1)) max(XL(2),XL1(2))]);
            ylim([min(YL(1), YL1(1)) max(YL(2),YL1(2))]);

            %clear text for output png to find boundaries
            set(gca,'visible','off')
            
            if len == 14
                xlim([0 2200])
                xticks([0 500 1000 1500 2000])
                yticks([-2000 -1500 -1000 -500 0 500 1000])
                set(gca, 'fontsize', 18)
            else
                set(gca,'XTick',[], 'YTick', []);
                xticks(min(XL(1), XL1(1)):100:max(XL(2),XL1(2)));
                yticks(min(YL(1), YL1(1)):100:max(YL(2),YL1(2)));
            end

            saveas(gcf, 'Cartesian.png');

            set(gca,'visible','on')

            xlabel('Resistance R');
            ylabel('Reactance X');
            
            if save_pdf_enable
                ax = gca;
                if MN_stub_setting == 1  
                    filename = sprintf('Cartesian_single stub_k=%.2f_%dmm_%.2fG_numV=5.pdf', k, len, f);
                    exportgraphics(ax,filename,'ContentType','vector');
                else
                    filename = sprintf('Cartesian_all_k=%.2f_%dmm_%.2fG_numV=5.pdf', k, len, f);
                    exportgraphics(ax,filename,'ContentType','vector');
                end
            end

            plot(circle_covercircle_x, circle_covercircle_y, 'LineWidth', line_width, 'Color', color_covercircle); 
            saveas(gcf, 'Cartesian_final.png');

            if ~Cartesian_only
                % plot on Smith Chart
                figure(6);
                set(gcf,'position',[0,0,scale*window_size,scale*window_size]);
                smithplot(0, 'GridVisible', 0, 'ColorOrder', colororder, 'LineWidth', line_width-1, 'ArcTickLabelVisible', 0, 'CircleTickLabelVisible', 0); % the Smith chart circle (used to be minused later)
                for q = 1:num_case + 1
                    smithplot(gamma(q,:), 'LineWidth', line_width, 'ColorOrder', colororder);             %% plot the circles one by one
                    hold on
                end
                smithplot(0, 'GridVisible', 0, 'ColorOrder', colororder, 'LineWidth', line_width-1, 'ArcTickLabelVisible', 0, 'CircleTickLabelVisible', 0); % the Smith chart circle (used to be minused later)
                saveas(gcf, 'Smith.png')

                smithplot(0, 'GridVisible', 1, 'ColorOrder', colororder, 'LineWidth', line_width-1, 'ArcTickLabelVisible', 1, 'CircleTickLabelVisible', 1); % the Smith chart circle (used to be minused later)
                smithplot(gamma_covercircle, 'LineWidth', line_width, 'ColorOrder', colororder);             %% plot the circles one by one
                saveas(gcf, 'Smith_final.png');
                
                if save_pdf_enable
                    ax = gca;
                    if MN_stub_setting == 1  
                        filename = sprintf('Smith_single stub_k=%.2f_%dmm_%.2fG_numV=5.pdf', k, len, f);
                        exportgraphics(ax,filename,'ContentType','vector');
                    else
                        filename = sprintf('Smith_all_k=%.2f_%dmm_%.2fG_numV=5.pdf', k, len, f);
                        exportgraphics(ax,filename,'ContentType','vector');
                    end
                end
            end
        end
    end 
     
     fprintf('Area percent: %f\n', area_percent(num_file));
     fprintf('Cover circle area percent: %f\n', cover_circle_area_percent(num_file));
     fprintf('Number of circles unshown: %d\n\n', num_unshown);
     
%      filename_save_mat = sprintf('two stub_k=%d_%dmm_%dMHz_numV=5', 10*k, len, f*1000);
%      save(filename_save_mat);

    % finding and display the boundary
    if Highlight_outline
        %cartesian 
        figure('Name', 'Cartesian_outline');
        set(gcf,'position',[0,0,scale * window_size_x,scale * window_size_y]);
        I_final = imread('Cartesian_final.png');
        imshow(I_final);
        hold on;
        I = imread('Cartesian.png');
        Cartesian_circle = im2bw(I, 0.9);
        [B0,L0,N0,A0] = bwboundaries(Cartesian_circle, 8, 'holes');

        for p = N0 + 1 : length(B0)
            boundary = B0{p}; 
            boundary(:, 2) = smooth(boundary(:, 2));
            boundary(:, 1) = smooth(boundary(:, 1));
            plot(boundary(:,2), boundary(:,1), 'Color', color_outline, 'LineWidth', line_width-1);
            hold on
        end 
        

        filename_savefig_Cartesian = sprintf('Cartesian_k=%.2f_%dmm_%.2fG_numV=5.png', k, len, f);
        saveas(gcf, filename_savefig_Cartesian);

        if ~Cartesian_only
            %smith
            figure('Name', 'Smithn_outline');
            set(gcf,'position',[0,0,scale*window_size,scale*window_size]);
            I_final = imread('Smith_final.png');
            imshow(I_final);
            hold on;
            I = imread('Smith.png');
            Smith_circle_outline = im2bw(I, 0.9);
            
            %clear the inner Smith circle to prevent continued circle to inner side
            for m = 1:length(boundary_smith_inner)
                Smith_circle_outline(boundary_smith_inner(m,2), boundary_smith_inner(m,1)) = 1;
            end
            
            [B0,L0,N0,A0] = bwboundaries(Smith_circle_outline, 8, 'holes');
            
            for p = N0 + 2 : length(B0)
                boundary = B0{p}; 
                
%                 if (boundary(1, 1) == 1218) && boundary(1, 2) == 390  % get rid of the weird outline on Smith outline
%                     continue
%                 end
                
                boundary(:, 2) = smooth(boundary(:, 2));
                boundary(:, 1) = smooth(boundary(:, 1));
                plot(boundary(:,2), boundary(:,1), 'Color', color_outline, 'LineWidth', line_width-1);
                hold on
            end 
            
            %plot inner vacancy outline
            I_filled = imread(filename_savefig_fill);
            Smith_circle_fill = im2bw(I_filled, 0.9);
            [B1,L1,N1,A1] = bwboundaries(Smith_circle_fill, 8, 'holes');
            for p = 3 : N1 
                boundary = B1{p}; 
                boundary(:, 2) = smooth(boundary(:, 2));
                boundary(:, 1) = smooth(boundary(:, 1));
                plot(boundary(:,2), boundary(:,1), 'Color', color_outline, 'LineWidth', line_width-1);
                hold on
            end 

            filename_savefig_Smith = sprintf('Smith_k=%.2f_%dmm_%.2fG_numV=5.png', k, len, f);
            saveas(gcf, filename_savefig_Smith);

        end
    end
    
end
