%%%Objective: get minimum and maximum global variables(x,y,z-diff) for all
%%%implants(glenoid, humeral)
%Author: Risha Chakraborty and Jonah Steuer, 2018
clear all; clc;

%%% OPTION TO CHOOSE ALL FILES IN A FOLDER. NOTE GLOBAL LOOP
home=pwd; addpath(home);
PathName = uigetdir; 
cd(PathName);
files=dir('*.txt');

file_numbers = [];     

for j = 1:length(files) 
    clean=importdata(files(j).name);
    file_numbers = [file_numbers ; clean(:,1:3)];
end

global_xmax = max(file_numbers(:,1));
global_xmin = min(file_numbers(:,1));

global_ymax = max(file_numbers(:,2));
global_ymin = min(file_numbers(:,2));

out_array = [];
perc_array = [];

for j = 1:length(files) 
    coord=importdata(files(j).name);
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
    for i = 1: length(x)
          correct_coord(i,3) = -sqrt(radius^2 - (coord(i, 1) - center(1)).^2 - (coord(i,2)-center(2)).^2) + center(3);
    end

    % identify scan area (boundary)
    xMax = max(coord(:,1)); xMin = min(coord(:,1));
    x = xMin;  %start scan at the far inferior end 
    x_inc = .02; % increment x value, consider points towards superior end
    %identify row matrix containing all incrments of x used
    x_int = xMin:x_inc:xMax; 

    %identify size of matrix supinffit_out(number of swaths = total distance
    %covered over x axis divided by increment) and fill with zeros(initialize)
    difference_out = zeros(floor((xMax-xMin)/x_inc),1); %%for retrieved
    difference_perc = zeros(floor((xMax-xMin)/x_inc),1); %%for retrieved

    idx = 0;  %initialize matrix used inside for loop
    ROI = 0;  %initialize matrix used inside for loop

    for i = 1:length(x_int) %%%for each swath considered
          if (i >= length(x_int) - 1) %%%if the swath is the final swath 
              %%%considered
             idx = find(coord(:,1) >= x_int(i)); %%%find points only within the 
              %%%final swath, fill in idx the x-values
          else
          idx = find(coord(:,1) >= x_int(i) & coord(:,1) <= x_int(i+1)); 
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
    
    perc_array = [difference_perc; perc_array]; %form array with all percentiles
    out_array = [difference_out; out_array];  %form array with all averages
end  

max_diff = max(out_array); %get max of average array
min_diff = min(out_array); %get min of average array
max_perc = max(perc_array); %get max of percentile array
min_perc = min(perc_array); %get min of percentile array
    