%%%Objective: graph average of tenth percentile of deformation of
%%%extremities along anterior-posterior axis, differentiating between total
%%%and reverse implants, and negative and positive deformation
%Author: Risha Chakraborty and Jonah Steuer, 2018
clc; clear all; close all;

%%%% OPTION TO CHOOSE ALL FILES IN A FOLDER. NOTE GLOBAL LOOP
home=pwd; addpath(home);
PathName = uigetdir; 
cd(PathName);
files=dir('*Cleaned_Up.txt');

percentile_Antpos_Total = [];

for j = 1:length(files)
    correct_coord = [];
    coord=importdata(files(j).name);


    %create column matrices with x-values, y-values, and z-values
    x=coord(:,1); y=coord(:,2);z=coord(:,3);

    % call least-squares spherical fit function with the deformed implant's points(consider entire implant) to get center and radius of original implant
    [center,radius,residuals] = lst_sq_sph_fit(coord(:, 1),coord(: , 2),coord(: , 3)); 
    
    %initialize array that will hold the z values of perfect implant
    correct_coord(:, 1) = coord(:,1);
    correct_coord(:,2) = coord(:,2);

    %plug in x and y coords into general sphere equation(using the previously calculated center and radius)
    %to create z values and fill in correct_coord
    for i = 1: length(x)
         correct_coord(i,3) = -sqrt(radius^2 - (coord(i, 1) - center(1)).^2 - (coord(i,2)-center(2)).^2) + center(3);
    end

    % identify scan area (boundary)
    yMax = max(coord(:,2)); yMin = min(coord(:,2));
    y = yMin;  %start scan at the far inferior end 

    y_inc = (yMax-yMin)/3; % increment x value, consider points towards superior end

    %identify row matrix containing all incrments of x used
    y_int = yMin:y_inc:yMax; 

    %identify size of matrix Antposfit_out(number of swaths = total distance
    %covered over x axis divided by increment) and fill with zeros(initialize)
    %percentile_out = zeros(floor((xMax-xMin)/x_inc),1);
    percentile_out = zeros(length(y_int) , 1);
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
      ROI_correct = correct_coord(idx, :);   %%%fill ROI with the coordinates with those x-values(x,y,z)
      ROI_retrieved = coord(idx, :);
      column = ROI_retrieved(:,3) - ROI_correct(:,3); %%%fill column vector with z-values of coordinates
      percentile = prctile(column, (90)); % calculate 90th percentile
      percentile_out(i,1) = percentile; 
      %%%add the average to percentile_out column array at index determined by for loop
    end
    percentile_Antpos_Total = [percentile_Antpos_Total; percentile_out];
end

%%%% OPTION TO CHOOSE ALL FILES IN A FOLDER. NOTE GLOBAL LOOP
home=pwd; addpath(home);
PathName = uigetdir; 
cd(PathName);
files=dir('*Clean.txt');

percentile_Antpos_Reverse = [];

for j = 1:length(files)
    correct_coord = [];
    coord=importdata(files(j).name);


    %create column matrices with x-values, y-values, and z-values
    x=coord(:,1); y=coord(:,2);z=coord(:,3);

    % call least-squares spherical fit function with the deformed implant's points(consider entire implant) to get center and radius of original implant
    [center,radius,residuals] = lst_sq_sph_fit(coord(:, 1),coord(: , 2),coord(: , 3)); 
    
    %initialize array that will hold the z values of perfect implant
    correct_coord(:, 1) = coord(:,1);
    correct_coord(:,2) = coord(:,2);

    %plug in x and y coords into general sphere equation(using the previously calculated center and radius)
    %to create z values and fill in correct_coord
    for i = 1: length(x)
         correct_coord(i,3) = -sqrt(radius^2 - (coord(i, 1) - center(1)).^2 - (coord(i,2)-center(2)).^2) + center(3);
    end

    % identify scan area (boundary)
    yMax = max(coord(:,2)); yMin = min(coord(:,2));
    x = yMin;  %start scan at the far inferior end 

    y_inc = (yMax-yMin)/3; % increment x value, consider points towards superior end

    %identify row matrix containing all incrments of x used
    y_int = yMin:y_inc:yMax; 

    %identify size of matrix Antposfit_out(number of swaths = total distance
    %covered over x axis divided by increment) and fill with zeros(initialize)
    %percentile_out = zeros(floor((xMax-xMin)/x_inc),1);
    percentile_out = zeros(length(y_int) , 1);
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
      ROI_correct = correct_coord(idx, :);   %%%fill ROI with the coordinates with those x-values(x,y,z)
      ROI_retrieved = coord(idx, :);
      column = ROI_retrieved(:,3) - ROI_correct(:,3); %%%fill column vector with z-values of coordinates
      percentile = prctile(column, (90)); % calculate 90th percentile
      percentile_out(i,1) = percentile; 
      %%%add the average to percentile_out column array at index determined by for loop
    end
    percentile_Antpos_Reverse = [percentile_Antpos_Reverse; percentile_out];
end

% Anterior_Total = sortrows(percentile_Antpos_Total(1:4:length(percentile_Antpos_Total)-3));
% Posterior_Total= sortrows(percentile_Antpos_Total(4:4:length(percentile_Antpos_Total)));

Anterior_Total = sortrows(percentile_Antpos_Total(1:3:length(percentile_Antpos_Total)-2));
Posterior_Total= sortrows(percentile_Antpos_Total(3:3:length(percentile_Antpos_Total)));

Anterior_Total_pos = [];
Anterior_Total_neg = [];

for i = 1:length(Anterior_Total)
    if Anterior_Total(i) > 0
        Anterior_Total_pos = [Anterior_Total(i,1) ; Anterior_Total_pos];
    else 
        Anterior_Total_neg = [Anterior_Total(i,1) ; Anterior_Total_neg];
    end
end
      
Posterior_Total_pos = [];
Posterior_Total_neg = [];

for i = 1:length(Posterior_Total)
    if Posterior_Total(i) > 0 
        Posterior_Total_pos = [Posterior_Total(i,1) ; Posterior_Total_pos];
    else 
        Posterior_Total_neg = [Posterior_Total(i,1) ; Posterior_Total_neg];
    end
end

% Anterior_Reverse = sortrows(percentile_Antpos_Reverse(1:4:length(percentile_Antpos_Reverse)-3));
% Posterior_Reverse = sortrows(percentile_Antpos_Reverse(4:4:length(percentile_Antpos_Reverse)));

Anterior_Reverse = sortrows(percentile_Antpos_Reverse(1:3:length(percentile_Antpos_Reverse)-2));
Posterior_Reverse = sortrows(percentile_Antpos_Reverse(3:3:length(percentile_Antpos_Reverse)));

Anterior_Reverse_pos = [];
Anterior_Reverse_neg = [];

for i = 1:length(Anterior_Reverse)
    if Anterior_Reverse(i) > 0 
        Anterior_Reverse_pos = [Anterior_Reverse(i,1) ; Anterior_Reverse_pos];
    else 
        Anterior_Reverse_neg = [Anterior_Reverse(i,1) ; Anterior_Reverse_neg];
    end
end
      
Posterior_Reverse_pos = [];
Posterior_Reverse_neg = [];

for i = 1:length(Posterior_Reverse)
    if Posterior_Reverse(i) > 0 
        Posterior_Reverse_pos = [Posterior_Reverse(i,1) ; Posterior_Reverse_pos];
    else 
        Posterior_Reverse_neg = [Posterior_Reverse(i,1) ; Posterior_Reverse_neg];
    end
end

%calculate average and standard deviation of positive total extremities
Total_Extremities_pos = mean([Anterior_Total_pos ; Posterior_Total_pos]) .* 100;
Total_extstd_pos = std([Anterior_Total_pos ; Posterior_Total_pos]) .* 100;
    
%calculate average and standard deviation of positive reverse extremities
Reverse_Extremities_pos = mean([Anterior_Reverse_pos ; Posterior_Reverse_pos]) .* 100;
Reverse_extstd_pos = std([Anterior_Reverse_pos ; Posterior_Reverse_pos]) .* 100;

%calculate average and standard deviation of negative total extremities
Total_Extremities_neg = mean([Anterior_Total_neg ; Posterior_Total_neg]) .* 100;
Total_extstd_neg = std([Anterior_Total_neg ; Posterior_Total_neg]) .* 100;

%calculate average and standard deviation of negative reverse extremities
Reverse_Extremities_neg = mean([Anterior_Reverse_neg ; Posterior_Reverse_neg]) .* 100;
Reverse_extstd_neg = std([Anterior_Reverse_neg ; Posterior_Reverse_neg]) .* 100;

hold on;

%graph bar chart

std_Total = [Total_extstd_pos Total_extstd_neg];
Total_label = categorical({'Total-Extremities-Positive' 'Total-Extremities-Negative'});
Total_value = [Total_Extremities_pos Total_Extremities_neg];
bar(Total_label, Total_value);


std_Reverse = [Reverse_extstd_pos Reverse_extstd_neg];
Reverse_label = categorical({'Reverse-Extremities-Positive' 'Reverse-Extremities-Negative'});
Reverse_value = [Reverse_Extremities_pos Reverse_Extremities_neg];
bar(Reverse_label, Reverse_value);

label_array = [Total_label ; Reverse_label];
value_array = [Total_value ; Reverse_value];
std_array = [std_Total ; std_Reverse];

for i = 1: length(label_array)
    errorbar(label_array(1,i), value_array(1,i) , std_array(1,i));
    errorbar(label_array(2,i), value_array(2,i) , std_array(2,i));
end


title('Surface Deformation of Reverse and Total Shoulder Arthroplasties');
xlabel('Type of Arthroplasty');
ylabel('Tenth Percentile of Z-values(mm)');
legend('Total' , 'Reverse');
hold off;
