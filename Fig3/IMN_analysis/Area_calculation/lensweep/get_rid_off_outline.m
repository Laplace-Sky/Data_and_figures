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
                
                if (boundary(1, 1) == 1218) && boundary(1, 2) == 390  % get rid of the weird outline on Smith outline
                    continue
                end
                
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