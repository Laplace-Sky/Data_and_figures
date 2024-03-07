% instructions:
% this is used to plot the process of impedance matching an original load
% impedance circle to the k radius concentric circle, firstly, the length
% of the main and opne stub should be selected and plug into the "test.nb"
% mathematica file and get the saved file into the same folder, then run
% this matlab script

close all; clear all
w_window = 900;
h_window = 900;

stub_case = 2;

mesh_resolution = 0.01;

l0 = 0.014;

d = 1.78e-3;
w = 3.5e-3;
epsilon_r = 4.28;
epsilon_e = (epsilon_r + 1) / 2 + (epsilon_r - 1) / 2 / sqrt(1 + 12 * d / w);

f = 2.45e9;
c = 3e8;
lambda = c / f ;
beta = 2 * pi / lambda * sqrt(epsilon_e);


k = 0.2;

Z0 = 50;
Y0 = 1 / Z0;

VSWR = (1 + k) / (1 - k);
r0 = Z0 * (VSWR - 1 / VSWR) / 2;
center0 = [(Z0 * (VSWR + 1 / VSWR) / 2) 0];

i = sqrt(-1);

if stub_case == 1
    m1 = 3;
    n1 = 4;
    len_main = m1 * l0;
    len_stub = n1 * l0;
    
    fid = fopen(sprintf('load_circle_location_single.txt'));
    data = textscan(fid, '%s','Delimiter', '&&');

    fclose(fid);
    %parse data from Mathematica
    for j = 1:length(data{1,1})
        if(j == 7)             %%parsing the x y coordinates of the circle center
            seg = split(string(data{1,1}(j)), ' ');

            seg1 = erase(seg(3,1), ')');
            seg1 = split(seg1(1,1), '*^');
            if(length(seg1) ~= 1)
                num_seg1(1) = str2double(seg1(1,1)) * 10^str2double(seg1(2,1));
            else
                num_seg1(1) = str2double(seg1(1,1));
            end
            center(1,2) = num_seg1(1);      %%y coordinates of all circle centers

            seg2 = erase(erase(seg(5,1), '(Inequality['), ',');
            seg2 = split(seg2(1,1), '*^');
            if(length(seg2) ~= 1)
                num_seg2(1) = str2double(seg2(1,1)) * 10^str2double(seg2(2,1));
            else
                num_seg2(1) = str2double(seg2(1,1));
            end
            seg3 = erase(seg(9,1), ']');
            if(length(seg3) ~= 1)
                num_seg3(1) = str2double(seg3(1,1)) * 10^str2double(seg3(2,1));
            else
                num_seg3(1) = str2double(seg3(1,1));
            end
            center(1,1) = (num_seg2(1) + num_seg3(1)) / 2;   %%x coordinates of all circle centers
        end

        if(j == 9)                          %%parsing the radius r of the circle
            seg4 = split(string(data{1,1}(j)), ' ');
            seg4 = split(seg4(3,1), '*Sqrt[');
            seg5 = split(seg4(1,1), '*^');
            if(length(seg5) ~= 1)
                num_seg5(1) = str2double(seg5(1,1)) * 10^str2double(seg5(2,1));
            else
                num_seg5(1) = str2double(seg5(1,1));
            end
            seg6 = split(seg4(2,1), '*^');
            if(length(seg6) ~= 1)
                num_seg6(1) = str2double(seg6(1,1)) * 10^str2double(seg6(2,1));
            else
                num_seg6(1) = str2double(seg6(1,1));
            end
            r(1) = sqrt(num_seg5(1)^2 * num_seg6(1) + center(1,1)^2);
        end
    end

    %construct points inside the original load circle
    x_mesh = [round((center(1) - r), -log10(mesh_resolution)):mesh_resolution:round(center(1) + r, -log10(mesh_resolution))];
    y_mesh = [round((center(2) - r), -log10(mesh_resolution)):mesh_resolution:round(center(2) + r, -log10(mesh_resolution))];
    [x y] = meshgrid(x_mesh, y_mesh);

    x_1 = zeros(size(x, 1), size(x, 2));
    y_1 = zeros(size(x, 1), size(x, 2));
    x_2 = zeros(size(x, 1), size(x, 2));
    y_2 = zeros(size(x, 1), size(x, 2));

    % for all points inside the square area
    for p = 1:size(x, 1)
        for j = 1:size(x, 2)
            if (x(p, j) - center(1))^2 + (y(p, j) - center(2))^2 <= r^2  % for points inside the load circle
               ZL = x(p, j) + i * y(p, j);
               YL = 1 / ZL;
               % find the impedance circle after d on main length
               Yin_d = Y0 * (YL + i * Y0 * tan(beta * len_main)) / (Y0 + i * YL * tan(beta * len_main));
               %Yin_d = Y0 * (YL + i * Y0 * tan((deg1 / 180) * pi)) / (Y0 + i * YL * tan((deg1 / 180) * pi));
               Zin_d = 1 / Yin_d;
               x_1(p, j) = real(Zin_d);
               y_1(p, j) = imag(Zin_d);
               % find the impedance circle after d with an open stub of l (this should be the k radius concentric circle)
               Yin_l = i * Y0 * tan(beta * len_stub);
               %Yin_l = i * Y0 * tan((deg2 / 180) * pi);
               Y = Yin_d + Yin_l;
               Z = 1 / Y;
               x_2(p, j) = real(Z);
               y_2(p, j) = imag(Z);
            end
        end   
    end

    % find out the center and radius in Cartesion coordinates of the circle 1 and circle 2
    x_1(x_1 == 0) = NaN;
    y_1(y_1 == 0) = NaN;
    center_1(1) = (max(x_1(:)) + min(x_1(:))) / 2;
    center_1(2) = (max(y_1(:)) + min(y_1(:))) / 2;
    r_1 = (max(x_1(:)) - min(x_1(:))) / 2;

    x_2(x_2 == 0) = NaN;
    y_2(y_2 == 0) = NaN;
    center_2(1) = (max(x_2(:)) + min(x_2(:))) / 2;
    center_2(2) = (max(y_2(:)) + min(y_2(:))) / 2;
    r_2 = (max(x_2(:)) - min(x_2(:))) / 2;

    %plot on Smith chart
    resolution = 100;

    for p = 1:(resolution + 1)
        circle_0_x(p) = r * cos((p - 1) * 2*pi/resolution) + center(1);
        circle_0_y(p) = r * sin((p - 1) * 2*pi/resolution) + center(2);
        Z_0(p) = circle_0_x(p) + i * circle_0_y(p);
        gamma0(p) = z2gamma(Z_0(p), Z0);

        circle_1_x(p) = r_1 * cos((p - 1) * 2*pi/resolution) + center_1(1);
        circle_1_y(p) = r_1 * sin((p - 1) * 2*pi/resolution) + center_1(2);
        Z1(p) = circle_1_x(p) + i * circle_1_y(p);
        gamma1(p) = z2gamma(Z1(p), Z0);

        circle_2_x(p) = r_2 * cos((p - 1) * 2*pi/resolution) + center_2(1);
        circle_2_y(p) = r_2 * sin((p - 1) * 2*pi/resolution) + center_2(2);
        Z2(p) = circle_2_x(p) + i * circle_2_y(p);
        gamma2(p) = z2gamma(Z2(p), Z0);
    end

    figure
    smithplot(gamma0);
    hold on
    smithplot(gamma1);
    smithplot(gamma2);
else
    m1 = 1;
    n1 = 2;
    m2 = 1;
    n2 = 3;
    % length in degree of the main line and the open stub
    len_main = m1 * l0; %m
    len_stub = n1 * l0; %m
    len_main_2 = m2 * l0; %m
    len_stub_2 = n2 * l0; %m
    
    fid = fopen(sprintf('load_circle_location_double.txt'));
    data = textscan(fid, '%s','Delimiter', '&&');
    for j = 1:length(data{1,1})
        if(mod(j,16) == 11)             %%parsing the x y coordinates of the circle center
            seg = split(string(data{1,1}(j)), ' ');

            seg1 = erase(seg(3,1), ')');
            seg1 = split(seg1(1,1), '*^');
            if(length(seg1) ~= 1)
                num_seg1(1) = str2double(seg1(1,1)) * 10^str2double(seg1(2,1));
            else
                num_seg1(1) = str2double(seg1(1,1));
            end
            center(1,2) = num_seg1(1);      %%y coordinates of all circle centers

            seg2 = erase(erase(seg(5,1), '(Inequality['), ',');
            seg2 = split(seg2(1,1), '*^');
            if(length(seg2) ~= 1)
                num_seg2(1) = str2double(seg2(1,1)) * 10^str2double(seg2(2,1));
            else
                num_seg2(1) = str2double(seg2(1,1));
            end
            seg3 = erase(seg(9,1), ']');
            seg3 = split(seg3(1,1), '*^');
            if(length(seg3) ~= 1)
                num_seg3(1) = str2double(seg3(1,1)) * 10^str2double(seg3(2,1));
            else
                num_seg3(1) = str2double(seg3(1,1));
            end
            center(1,1) = (num_seg2(1) + num_seg3(1)) / 2;   %%x coordinates of all circle centers
        end

        if(mod(j,16) == 13)                          %%parsing the radius r of the circle
            seg4 = split(string(data{1,1}(j)), ' ');
            seg4 = split(seg4(3,1), '*Sqrt[');
            seg5 = split(seg4(1,1), '*^');
            if(length(seg5) ~= 1)
                num_seg5(1) = str2double(seg5(1,1)) * 10^str2double(seg5(2,1));
            else
                num_seg5(1) = str2double(seg5(1,1));
            end
            seg6 = split(seg4(2,1), '*^');
            if(length(seg6) ~= 1)
                num_seg6(1) = str2double(seg6(1,1)) * 10^str2double(seg6(2,1));
            else
                num_seg6(1) = str2double(seg6(1,1));
            end
            r(1) = sqrt(num_seg5(1)^2 * num_seg6(1) + center(1,1)^2);
        end     
    end
    
    %construct points inside the original load circle
    x_mesh = [round((center(1) - r), -log10(mesh_resolution)):mesh_resolution:round(center(1) + r, -log10(mesh_resolution))];
    y_mesh = [round((center(2) - r), -log10(mesh_resolution)):mesh_resolution:round(center(2) + r, -log10(mesh_resolution))];
    [x y] = meshgrid(x_mesh, y_mesh);

    x_1 = zeros(size(x, 1), size(x, 2));
    y_1 = zeros(size(x, 1), size(x, 2));
    x_2 = zeros(size(x, 1), size(x, 2));
    y_2 = zeros(size(x, 1), size(x, 2));
    x_3 = zeros(size(x, 1), size(x, 2));
    y_3 = zeros(size(x, 1), size(x, 2));
    x_4 = zeros(size(x, 1), size(x, 2));
    y_4 = zeros(size(x, 1), size(x, 2));

    % for all points inside the square area
    for p = 1:size(x, 1)
        for j = 1:size(x, 2)
            if (x(p, j) - center(1))^2 + (y(p, j) - center(2))^2 <= r^2  % for points inside the load circle
               %load circle
               ZL = x(p, j) + i * y(p, j);
               YL = 1 / ZL;
               
               % find the impedance circle after d1 on main length
               Yin_d1 = Y0 * (YL + i * Y0 * tan(beta * len_main)) / (Y0 + i * YL * tan(beta * len_main));
               Zin_d1 = 1 / Yin_d1;
               x_1(p, j) = real(Zin_d1);
               y_1(p, j) = imag(Zin_d1);
               
               % find the impedance circle after d1 with an open stub of l1
               Yin_l1 = i * Y0 * tan(beta * len_stub);
               Ytotal1 = Yin_d1 + Yin_l1;
               Ztotal1 = 1 / Ytotal1;
               x_2(p, j) = real(Ztotal1);
               y_2(p, j) = imag(Ztotal1);
               
               % find the impedance circle after d2 on main length
               Yin_d2 = Y0 * (Ytotal1 + i * Y0 * tan(beta * len_main_2)) / (Y0 + i * Ytotal1 * tan(beta * len_main_2));
               Zin_d2 = 1 / Yin_d2;
               x_3(p, j) = real(Zin_d2);
               y_3(p, j) = imag(Zin_d2);
               
               % find the impedance circle after d2 with an open stub of l2
               Yin_l2 = i * Y0 * tan(beta * len_stub_2);
               Ytotal = Yin_d2 + Yin_l2;
               Ztotal = 1 / Ytotal;
               x_4(p, j) = real(Ztotal);
               y_4(p, j) = imag(Ztotal);
            end
        end   
    end

    % find out the center and radius in Cartesion coordinates of the circle 1, circle 2, circle 3, circle 4
    x_1(x_1 == 0) = NaN;
    y_1(y_1 == 0) = NaN;
    center_1(1) = (max(x_1(:)) + min(x_1(:))) / 2;
    center_1(2) = (max(y_1(:)) + min(y_1(:))) / 2;
    r_1 = (max(x_1(:)) - min(x_1(:))) / 2;

    x_2(x_2 == 0) = NaN;
    y_2(y_2 == 0) = NaN;
    center_2(1) = (max(x_2(:)) + min(x_2(:))) / 2;
    center_2(2) = (max(y_2(:)) + min(y_2(:))) / 2;
    r_2 = (max(x_2(:)) - min(x_2(:))) / 2;
    
    x_3(x_3 == 0) = NaN;
    y_3(y_3 == 0) = NaN;
    center_3(1) = (max(x_3(:)) + min(x_3(:))) / 2;
    center_3(2) = (max(y_3(:)) + min(y_3(:))) / 2;
    r_3 = (max(x_3(:)) - min(x_3(:))) / 2;

    x_4(x_4 == 0) = NaN;
    y_4(y_4 == 0) = NaN;
    center_4(1) = (max(x_4(:)) + min(x_4(:))) / 2;
    center_4(2) = (max(y_4(:)) + min(y_4(:))) / 2;
    r_4 = (max(x_4(:)) - min(x_4(:))) / 2;

    %plot on Smith chart
    resolution = 100;

    for p = 1:(resolution + 1)
        circle_0_x(p) = r * cos((p - 1) * 2*pi/resolution) + center(1);
        circle_0_y(p) = r * sin((p - 1) * 2*pi/resolution) + center(2);
        Z_0(p) = circle_0_x(p) + i * circle_0_y(p);
        gamma0(p) = z2gamma(Z_0(p), Z0);

        circle_1_x(p) = r_1 * cos((p - 1) * 2*pi/resolution) + center_1(1);
        circle_1_y(p) = r_1 * sin((p - 1) * 2*pi/resolution) + center_1(2);
        Z1(p) = circle_1_x(p) + i * circle_1_y(p);
        gamma1(p) = z2gamma(Z1(p), Z0);

        circle_2_x(p) = r_2 * cos((p - 1) * 2*pi/resolution) + center_2(1);
        circle_2_y(p) = r_2 * sin((p - 1) * 2*pi/resolution) + center_2(2);
        Z2(p) = circle_2_x(p) + i * circle_2_y(p);
        gamma2(p) = z2gamma(Z2(p), Z0);
        
        circle_3_x(p) = r_3 * cos((p - 1) * 2*pi/resolution) + center_3(1);
        circle_3_y(p) = r_3 * sin((p - 1) * 2*pi/resolution) + center_3(2);
        Z3(p) = circle_3_x(p) + i * circle_3_y(p);
        gamma3(p) = z2gamma(Z3(p), Z0);
        
        circle_4_x(p) = r_4 * cos((p - 1) * 2*pi/resolution) + center_4(1);
        circle_4_y(p) = r_4 * sin((p - 1) * 2*pi/resolution) + center_4(2);
        Z4(p) = circle_4_x(p) + i * circle_4_y(p);
        gamma4(p) = z2gamma(Z4(p), Z0);
    end

    figure
    smithplot(gamma0);
    hold on
    smithplot(gamma1);
    smithplot(gamma2);
    smithplot(gamma3);
    smithplot(gamma4, 'ColorOrder', [1 0 0; 0 1 0; 0 0 1; 1 1 0; 0 0 0]);
end

set(gcf,'position',[[200, 200], w_window, h_window]);
set(gcf,'color','w');
% deg1 = 93.62;
% deg2 = 54.1;
% ZL = 60 - 75i;
% YL = 1 / ZL;
% Yin_d = Y0 * (YL + i * Y0 * tan((deg1 / 180) * pi)) / (Y0 + i * YL * tan((deg1 / 180) * pi));
% Yin_l = i * Y0 * tan((deg2 / 180) * pi);
% 
% d = deg1 / 180 * pi / beta
% l = deg2 / 180 * pi / beta
% 
% Y = Yin_d + Yin_l;
% Z = 1 / Y
           



