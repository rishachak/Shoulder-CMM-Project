%%%Objective: graph average of 10th percentile of deformation of
%%%extremities(along inferior-superior axis) and middle regions for all implants with certain
%%%property/classification(x-axis)
%Author: Risha Chakraborty and Jonah Steuer, 2018
clc; clear all; close all;

%%%% OPTION TO CHOOSE ALL FILES IN A FOLDER. NOTE GLOBAL LOOP
home=pwd; addpath(home);
PathName = uigetdir; 
cd(PathName);
files=dir('*.txt');

percentile_Supinf = [];

for j = 1:length(files)
    coord=importdata(files(j).name);
    correct_coord = [];

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
    x_inc = (xMax-xMin)/2; % increment x value, consider points towards superior end
    %identify row matrix containing all incrments of x used
    x_int = xMin:x_inc:xMax; 

    %identify size of matrix supinffit_out(number of swaths = total distance
    %covered over x axis divided by increment) and fill with zeros(initialize)
    percentile_out = zeros(length(x_int) , 1);

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
         perc = prctile(column , [90]); %%%get tenth percentile for each swath
         percentile_out(i,1) = perc; %%%store values
     end

    percentile_Supinf = [percentile_Supinf; percentile_out];
end

%call Trend files to put matrices with patient data in workspace
Trend_Setter_Total
Trend_Setter_Reverse
Trend_Binning

%assign doc to desired data matrix
doc = patient_sex_Total;

%fill inferior, middle, superior matrices with tenth-percentiles of
%respective regions from percentile_Supinf

%divide implant into equal thirds
Inferior_Third = sortrows(percentile_Supinf(1:3:length(percentile_Supinf)-2));
Middle_Third = sortrows(percentile_Supinf(2:3:length(percentile_Supinf)-1));
Superior_Third= sortrows(percentile_Supinf(3:3:length(percentile_Supinf)));

%divide implant into 50% extremities and 50% middle
% Inferior_Third = sortrows(percentile_Supinf(1:4:length(percentile_Supinf)-3));
% Middle_Third = sortrows([(percentile_Supinf(2:4:length(percentile_Supinf)-2));(percentile_Supinf(3:4:length(percentile_Supinf)-1))]);
% Superior_Third= sortrows(percentile_Supinf(4:4:length(percentile_Supinf)));

%form dictionary with keys of the different classifications of data
%(classifications in trend files and in doc) and with values representing number of
%times the key is found in the data matrix
type_array = containers.Map('KeyType','char','ValueType','double');
for i = 1:length(doc)
          if isKey(type_array , doc(i)) == 1 
                type_array(doc(i)) = type_array(doc(i)) + 1;
          elseif isKey(type_array , doc(i)) == 0 
               type_array(doc(i)) = 1;
          end
end

%form cell array out of dictionary that will hold data classifications
type_array = cell2mat(keys(type_array));

%form empty arrays holding percentiles for each region for each
%classification of implant
Superior = [];
Middle = [];
Inferior = [];

for i = 1 : length(type_array) %for all classifications found in type_array
    if type_array(i) ~= ' ' %if the data classification is not NaN or empty character
        idx = find(doc == type_array(i)); %find all indices in doc that have the classification 
        for j = idx(1): idx(length(idx)) %for all indices(implant number)
          Inferior(j,i) = Inferior_Third(j); %fill Inferior with percentile of that implant number in the jth row
          Middle(j,i) = Middle_Third(j); %fill Middle with percentile of that implant number in the jth row
          Superior(j,i) = Superior_Third(j); %fill Superior with percentile of that implant number in the jth row
        end
    end
end

%form empty arrays holding standard deviations for each bar in bar graph
extstd = [];
midstd = [];

   
real_Extremities = [];
for i = 2: length(type_array) %for all columns except for the first(holds NaN or 0 values)
    Middle_col = Middle(:,i); %fill array with all values in that column
    real_Middle(i) = mean(Middle_col((Middle_col ~= 0))) .* 100; %take average of all values in that column that are not equal to 0(zeros append non-zero values)
    midstd(i) = std(Middle_col((Middle_col ~= 0))) .* 100; %take standard deviation of all values in that column that are not equal to 0(zeros append non-zero values)
    
    Superior_col = Superior(:,i); %fill array with all values in that column
    Inferior_col = Inferior(:,i); %fill array with all values in that column
    
    realsup_col = Superior_col((Superior_col ~= 0)); %make array with all values except appending zeros
    realinf_col = Inferior_col((Inferior_col ~= 0)); %make array with all values except appending zeros
    
    real_Extremities(i) = (mean(realinf_col) + mean(realsup_col)) .*50 ; %find average of concatenated array with superior and inferior values
    extstd(i) = std([realsup_col ; realinf_col])  .* 100; %find standard deviation of concatenated array with superior and inferior values
end

hold on;

real_Extremities(1) = [];
real_Middle(1) = [];
extstd(1) = [];
midstd(1) = [];

%set 1st column of each array to blank
label_array = []; %contains all labels
value_array = []; %contains all values

for i = 2:length(type_array) 
    current_label = categorical({strcat('Extremities -', type_array(i)) , strcat('Middle- ' , type_array(i))});  %append labels to array containing all labels
    
    label_array = [label_array ; current_label]; %append labels to array containing all labels
    
    current_value = [real_Extremities(i-1), real_Middle(i-1)]; %get values of current subvar
    value_array = [value_array ; current_value]; %append values to array containing all values
    bar(current_label, current_value); %bar graph label and value
end

for i = 1: length(label_array) %add error bar using standard deviation
    errorbar(label_array(i,1), value_array(i,1) , extstd(i) , 'k');
    errorbar(label_array(i,2) , value_array(i,2) , midstd(i) , 'k');
end

%all legends for each external factor

% title('Surgery Arm Against Average Difference');
% xlabel('Surgery Arm');
% ylabel('Tenth Percentile of Z-values(mm)');
% legend('Left' , 'Right');
% % 
% title('Patient Sex Against Average Difference');
% xlabel('Patient Sex');
% ylabel('Tenth Percentile of Z-values(mm)');
% legend('Female' , 'Male');
% % 
% title('Size Against Average Difference');
% xlabel('Size');
% ylabel('Tenth Percentile of Z-values(mm)');
% legend('Size 48' , 'Size 44' , 'Standard' , 'Size 36' , 'Size 52');
% 
% title('Type of Polyethylene Against Average Difference');
% xlabel('Type of Polyethylene');
% ylabel('Tenth Percentile of Z-values(mm)');
% legend('Conventional' , 'Hylamer' , 'Cross-linked' );
%
% title('Patient Age Against Average Difference');
% xlabel('Patient Age');
% ylabel('Tenth Percentile of Z-values(mm)');
% legend('30 - 50' , '50 - 70' , '70 - 90');
% 
% title('Time in Vivo Against Average Difference');
% xlabel('Time in Vivo(years)');
% ylabel('Tenth Percentile of Z-values(mm)');
% %legend('0 - 2' , '2 - 8' , '8+');  %%%%TOTAL
% legend('0 - 2' , '2 - 8');   %%%%REVERSE
% 

%set y axis limits

ylim([0 20/10]);


hold off;





