clear all
close all
l_window = 450;

theta_step = 2;

line_width = 5;

plot_sim = 1;
normalize = 1;
calc_withsub = 0;
sim_withsub = 1; 

colororder = [0 0 0; 1 0 0; 0 0.65 0];

if plot_sim
    color_order = [colororder(1,:); colororder(1,:);
                   colororder(2,:); colororder(2,:);
                   colororder(3,:); colororder(3,:)];
    line_style = {'-', ':', '-', ':'};
else
    color_order = [colororder(1,:);
                   colororder(2,:);
                   colororder(3,:)];
    line_style = '-';
end

if normalize
    gain_min_plot = -40; %db
    rlim_max = 1;
else
    gain_min_plot = -60; %db
    rlim_max = 1;
end


j=sqrt(-1);
l = 0.01; %m
h = 0.00178; %m
I0 = 0.175;%60;  %5 for no sub
eta = 120 * pi; %ohm



syms theta phi

theta = -pi/2:pi/(180/theta_step):pi/2;
phi = 0;
phi2 = pi/2;

figure(1)
set(gcf,'position',[[100 100],l_window, l_window]);
set(gcf,'color','w');
hold on

figure(2)
set(gcf,'position',[[100 100],l_window, l_window]);
set(gcf,'color','w');
hold on


for f = 2.45e9
    omega = 2 * pi * f;
    mu = 1.25663706212e-6;
    epsilon = 8.8541878176e-12;
    
    if calc_withsub
        k = 2*pi/(3e8/f) / sqrt(3.2691);
    else
        k = sqrt(omega^2 * mu * epsilon);
    end
    
    %E plane
    rad_intensity_ground_0 = (1/32).*epsilon.^(-1).*I0.^2.*k.^3.*l.^2.*omega.^(-1).*pi.^(-2).* ...
      (cos (theta).^4+(1/2).*(3+4.*k.^2.*l.^2+( ...
      1+4.*k.^2.*l.^2).*cos(2.*phi)).*cos (theta).^2.*sin (theta).^2+(1+ ...
      4.*k.^2.*l.^2).*cos (phi).^4.*sin (theta).^4+sin (phi).^2.*(16.* ...
      k.^2.*l.^2.*sin (theta).^2+cos (phi).^2.*sin (theta).^4)).*sin (h.*k.* ...
      cos(theta)).^2;
  


    %H plane
    rad_intensity_ground_90 = (1/32).*epsilon.^(-1).*I0.^2.*k.^3.*l.^2.*omega.^(-1).*pi.^(-2).* ...
      (cos (theta).^4+(1/2).*(3+4.*k.^2.*l.^2+( ...
      1+4.*k.^2.*l.^2).*cos(2.*phi2)).*cos (theta).^2.*sin (theta).^2+(1+ ...
      4.*k.^2.*l.^2).*cos (phi2).^4.*sin (theta).^4+sin (phi2).^2.*(16.* ...
      k.^2.*l.^2.*sin (theta).^2+cos (phi2).^2.*sin (theta).^4)).*sin (h.*k.* ...
      cos(theta)).^2;
  

    if normalize
        rad_intensity_ground_0 = rad_intensity_ground_0./max(rad_intensity_ground_0);
        rad_intensity_ground_90 = rad_intensity_ground_90./max(rad_intensity_ground_90);
        gain_min_plot = -40;

    end
    
    for i = 1:length(rad_intensity_ground_0)
        rad_intensity_ground_0(i) = max(10*log10(rad_intensity_ground_0(i)), gain_min_plot);
        rad_intensity_ground_90(i) = max(10*log10(rad_intensity_ground_90(i)), gain_min_plot);
    end
    
    

    figure(1)

    %polarplot(theta, rad_intensity_ground_0)
    p = polarpattern(180/pi*theta,rad_intensity_ground_0, 'AngleDirection', 'CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'LineWidth', line_width, 'LineStyle', line_style, 'ColorOrder', color_order, ...
        'AngleAtTop', 0, 'TitleTopOffset', 0.15, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [rlim_max gain_min_plot], 'AngleTickLabelFormat', '180');
    hold on
    %polarplot(theta,10*log10(RF_surface_0_gain))


    figure(2)

    %polarplot(theta,rad_intensity_ground_90)
    p = polarpattern(180/pi*theta,rad_intensity_ground_90, 'AngleDirection', 'CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'LineWidth', line_width, 'LineStyle', line_style, 'ColorOrder', color_order, ...
        'AngleAtTop', 0, 'TitleTopOffset', 0.15, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [rlim_max gain_min_plot], 'AngleTickLabelFormat', '180');
    hold on
    
    if plot_sim

        if sim_withsub
            %RF_surface_0 = csvread(sprintf('%.1fG_E_smallsub.csv', f/1e9), 1);
            RF_surface_0 = csvread(sprintf('PEC_%.2fG_E_smallsub.csv', f/1e9), 1);
        else
            RF_surface_0 = csvread(sprintf('%.1fG_E.csv', f/1e9), 1);
        end
        
        RF_surface_0_gain = RF_surface_0(:, 2);
        if normalize
            RF_surface_0_gain = RF_surface_0_gain - max(RF_surface_0_gain);
        end

        if sim_withsub
            %RF_surface_90 = csvread(sprintf('%.1fG_H_smallsub.csv', f/1e9), 1);
            RF_surface_90 = csvread(sprintf('PEC_%.2fG_H_smallsub.csv', f/1e9), 1);
        else
            RF_surface_90 = csvread(sprintf('%.1fG_H.csv', f/1e9), 1);
        end
        RF_surface_90_gain = RF_surface_90(:, 2);
        if normalize
            RF_surface_90_gain = RF_surface_90_gain - max(RF_surface_90_gain);
        end
        
        figure(1)
        p = polarpattern(RF_surface_0(:, 1),RF_surface_0_gain, 'AngleDirection', 'CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'LineWidth', line_width, 'LineStyle', line_style, 'ColorOrder', color_order, ...
        'AngleAtTop', 0, 'TitleTopOffset', 0.15, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [rlim_max gain_min_plot], 'AngleTickLabelFormat', '180',...
        'MagnitudeFontSizeMultiplier', 900/l_window, 'AngleFontSizeMultiplier', 900/l_window);
 
    
        figure(2)
        p = polarpattern(RF_surface_90(:, 1),RF_surface_90_gain, 'AngleDirection', 'CW', 'ConnectEndpoints', 1, 'AngleResolution', 30, 'LineWidth', line_width, 'LineStyle', line_style, 'ColorOrder', color_order, ...
        'AngleAtTop', 0, 'TitleTopOffset', 0.15, 'MagnitudeAxisAngle', 0, 'MagnitudeLim', [rlim_max gain_min_plot], 'AngleTickLabelFormat', '180',...
        'MagnitudeFontSizeMultiplier', 900/l_window, 'AngleFontSizeMultiplier', 900/l_window);

    
%     for i = 90 / theta_step + 1 : 270 / theta_step + 1
%         RF_surface_0_gain(i) = 10^(gain_min_plot/10);
%         rad_intensity_ground_0(i) = 10^(gain_min_plot/10);
%         RF_surface_90_gain(i) = 10^(gain_min_plot/10);
%         rad_intensity_ground_90(i) = 10^(gain_min_plot/10);
%     end
    end
end
%polarplot(theta,10*log10(RF_surface_90_gain))
figure(1)
%legend({'Calculated 0.5GHz', 'Simulated 0.5GHz', 'Calculated 1.5GHz', 'Simulated 1.5GHz', 'Calculated 2.5GHz', 'Simulated 2.5GHz'}, 'location', [0.09 0.12 0.15 0.06], 'fontsize', 18);

%legend({'Calculated', 'Simulated'}, 'location', [0.08 0.12 0.15 0.06], 'fontsize', 24);

figure(2)
%legend({'Calculated 0.5GHz', 'Simulated 0.5GHz', 'Calculated 1.5GHz', 'Simulated 1.5GHz', 'Calculated 2.5GHz', 'Simulated 2.5GHz'}, 'location', [0.09 0.12 0.15 0.06], 'fontsize', 18);
%legend({'Calculated', 'Simulated'}, 'location', [0.08 0.12 0.15 0.06], 'fontsize', 24);
