clear all
close all

IMN_stub_setting = 2;    % 0 for both one and two stub cases; 1 for single stub only; 2 for two stub only;

num_H = 6;
num_V = 5;

f = 2.45; %GHz
k = 0.2;
len = 14;  %mm

%% single stub cases
if (IMN_stub_setting == 0) || (IMN_stub_setting == 1)
    num_case = (num_H - 1) * num_V;

    filename = sprintf('single stub_k=%.2f_%dmm_%.2fG_numV=5.txt', k, len, f);
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

    center
    r

    % plot on Cartesion coordinate
    figure(1);
    set(gcf,'position',[200,50,600,1250]);
    Z0 = 50;
    resolution = 100;
    circle_x = zeros(num_case, resolution + 1);
    circle_y = zeros(num_case, resolution + 1);
    Z = zeros(num_case, resolution + 1);
    gamma = zeros(num_case, resolution + 1);
    i = sqrt(-1);

    % plot the concentric circle with k radius (main line only case)
    VSWR = (1 + k) / (1 - k);
    r0 = Z0 * (VSWR - 1 / VSWR) / 2;
    center0 = [(Z0 * (VSWR + 1 / VSWR) / 2) 0];

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
        plot(circle_x(q,:), circle_y(q,:));               %% plot the circles one by one
        hold on
    end

    daspect([1 1 1])
    xlabel('Resistance R');
    ylabel('Reactance X');

    % plot on Smith Chart
    figure(2);
    set(gcf,'position',[900,50,1250,1250]);
    for q = 1:num_case + 1
        smithplot(gamma(q,:));             %% plot the circles one by one
        hold on
    end
end


%% two stub cases
if (IMN_stub_setting == 0) || (IMN_stub_setting == 2)
    num_case = nchoosek(num_H - 1, 2) * num_V * num_V;

    filename = sprintf('two stub_k=%.2f_%dmm_%.2fG.txt', k, len, f);
    fid = fopen(filename);
    data = textscan(fid, '%s','Delimiter', '&&')

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

    center
    r

    % plot on Cartesion coordinate
    figure(1);

    Z0 = 50;
    resolution = 100;
    circle_x = zeros(num_case, resolution + 1);
    circle_y = zeros(num_case, resolution + 1);
    Z = zeros(num_case, resolution + 1);
    gamma = zeros(num_case, resolution + 1);
    i = sqrt(-1);

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
        plot(circle_x(q,:), circle_y(q,:));               %% plot the circles one by one
        hold on
    end

    % plot on Smith Chart
    figure(2);
    for q = 1:num_case
        smithplot(gamma(q,:));             %% plot the circles one by one
        hold on
    end
end