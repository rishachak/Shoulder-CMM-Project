%%%OBJECTIVE: graphs average deformation 
%(absolute value of difference of z-values between correct and retrieved implants)
%of swaths of implant considered from one end to the other 
%along the anterior-posterior axis
%Author: Risha Chakraborty and Jonah Steuer, 2018


realGlobals % run to get global variables in workspace


%%%% OPTION TO CHOOSE A SINGLE FILE
[FileName,PathName] = uigetfile('*.*');
file = sprintf('%s%s',PathName,FileName);
coord=importdata(file);
%%%%%

    
%create column matrices with x-values, y-values, and z-values
x=coord(:,1); y=coord(:,2);z=coord(:,3);


%call least-squares spherical fit function
%with the deformed implant's points(consider entire implant)
%to get center and radius of original implant
[center,radius,residuals] = lst_sq_sph_fit(coord(:, 1),coord(: , 2),coord(: , 3)); 


%initialize array that will hold the z values of perfect implant
correct_coord = zeros(length(z),3);
correct_coord(:, 1:2) = coord(:,1:2);

%plug in x and y coords into general sphere equation(using the previously calculated center and radius)
%to create z values and fill in correct_coord
for i = 1: length(y)
   correct_coord(i,3) = -sqrt(radius^2 - (coord(i, 1) - center(1)).^2 - (coord(i,2)-center(2)).^2) + center(3);
end

% identify scan area (boundary)
yMax = max(coord(:,2)); yMin = min(coord(:,2));
y = yMin;  %start scan at the far inferior end 
y_inc = .02; % increment x value, consider points towards superior end
%identify row matrix containing all incrments of x used
y_int = yMin:y_inc:yMax; 

%identify size of matrix supinffit_out(number of swaths = total distance
%covered over x axis divided by increment) and fill with zeros(initialize)
difference_out = zeros(floor((yMax-yMin)/y_inc),1); %%for retrieved
difference_perc = zeros(floor((yMax-yMin)/y_inc),1); %%for retrieved


idx = 0;  %initialize matrix used inside for loop
ROI = 0;  %initialize matrix used inside for loop

for i = 1:length(y_int) %%%for each swath considered
    if (i >= length(y_int) - 1) %%%if the swath is the final swath 
        %%%considered
        idx = find(coord(:,2) >= y_int(i)); %%%find points only within the 
        %%%final swath, fill in idx the x-values
    else
        idx = find(coord(:,2) >= y_int(i) & coord(:,2) <= y_int(i+1)); 
        %%%find points between the previous line and next line, 
        %%%fill in idx the x-values
    end
    ROI = coord(idx,1:3); %%%fill ROI with the coordinates with retrieved x-values(x,y,z)
    ROIC = correct_coord(idx, 1:3); %%%fill ROI with the coordinates with correct x-values(x,y,z)
    ROI_diff = abs(ROIC - ROI); %%%get difference between corresponding points(abs)
    column = ROI_diff(:,3);
    avg = mean(column); %%%get average for each swath
    perc = prctile(column , [90]); %%%get tenth percentile for each swath
    difference_out(i,1) = avg; %%%store values 
    difference_perc(i,1) = perc; %%%store values
end

y_axis = (transpose(y_int) * 25.4) + abs((-1.22 * 25.4));

figure(i+1);
hold on;

%plot average difference and percentile difference against x_axis

scatter(y_axis, difference_out, 60 , 'k' , 'filled' ); hold on; 
scatter(y_axis, difference_perc, 60 , 'r' , 'filled' ); hold on;
plot(y_axis, difference_out , 'k')
plot(y_axis, difference_perc , 'r')
xlabel('A.P. Distance(mm)'); ylabel('Difference in Z-Values(mm)');
legend('Average' , 'Tenth Percentile');
title(strcat(FileName(1:3) ,  '  Effect of Posteriority on Surface Deformation'));
set(gca,'FontSize',18);

%%%choose axes, first option for global max-perc and min-perc for
%%%y-axis(only if break is necessary) , second option for default 0 - 0.4
%%%y-axis

%axis([((global_ymin*25.4) + abs(global_ymin*25.4)) (global_ymax*25.4 + abs(global_ymin*25.4)) min_perc max_perc]);
% breakyaxis([0.06,0.1]);
axis([((global_ymin*25.4) + abs(global_ymin*25.4)) (global_ymax*25.4 + abs(global_ymin*25.4)) 0 0.04]);
text((global_ymin*25.4) + abs(global_ymin*25.4), max_perc, 'Anterior');
text((global_ymax*25.4 + abs(global_ymin*25.4)), max_perc, 'Posterior');
hold off;

