%%%Objective: graph average of 10th percentile of deformation of
%%%extremities(along anterior-posterior axis) and middle regions for all implants with certain
%%%property/classification(x-axis)
%Author: Risha Chakraborty and Jonah Steuer, 2018
clc; clear all; close all;

%%%% OPTION TO CHOOSE ALL FILES IN A FOLDER. NOTE GLOBAL LOOP
home=pwd; addpath(home);
PathName = uigetdir; 
cd(PathName);
files=dir('*.txt');

percentile_Antpos = [];

for j = 1:length(files)
    correct_coord = [];
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
    for i = 1: length(y)
      correct_coord(i,3) = -sqrt(radius^2 - (coord(i, 1) - center(1)).^2 - (coord(i,2)-center(2)).^2) + center(3);
    end

    % identify scan area (boundary)
    yMax = max(coord(:,2)); yMin = min(coord(:,2));
    y = yMin;  %start scan at the far inferior end 
    y_inc = (yMax-yMin)/2; % increment x value, consider points towards superior end
    %identify row matrix containing all incrments of x used
    y_int = yMin:y_inc:yMax; 

    %identify size of matrix supinffit_out(number of swaths = total distance
    %covered over x axis divided by increment) and fill with zeros(initialize)
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
         ROI = coord(idx,1:3); %%%fill ROI with the coordinates with retrieved x-values(x,y,z)
         ROIC = correct_coord(idx, 1:3); %%%fill ROI with the coordinates with correct x-values(x,y,z)
         ROI_diff = abs(ROIC - ROI); %%%get difference between corresponding points(abs)
         column = ROI_diff(:,3);
         perc = prctile(column , [90]); %%%get tenth percentile for each swath
         percentile_out(i,1) = perc; %%%store values
     end

    percentile_Antpos = [percentile_Antpos; percentile_out];
end

%call Trend files to put matrices with patient data in workspace
Trend_Setter_Total
Trend_Setter_Reverse
Trend_Binning

%assign doc to desired data matrix
doc = patient_arm_Reverse;

%fill anterior, middle, posterior matrices with tenth-percentiles of
%respective regions from percentile_Supinf

%divide implant into equal thirds
Anterior_Third = sortrows(percentile_Antpos(1:3:length(percentile_Antpos)-2));
Middle_Third = sortrows(percentile_Antpos(2:3:length(percentile_Antpos)-1));
Posterior_Third= sortrows(percentile_Antpos(3:3:length(percentile_Antpos)));

%divide implant into 50% extremities and 50% middle
% Anterior_Third = sortrows(percentile_Antpos(1:4:length(percentile_Antpos)-3));
% Middle_Third = sortrows([(percentile_Antpos(2:4:length(percentile_Antpos)-2));(percentile_Antpos(3:4:length(percentile_Antpos)-1))]);
% Posterior_Third= sortrows(percentile_Antpos(4:4:length(percentile_Antpos)));

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
Posterior = [];
Middle = [];
Anterior = [];

for i = 1 : length(type_array) %for all classifications found in type_array
    if type_array(i) ~= ' ' %if the data classification is not NaN or empty character
        idx = find(doc == type_array(i)); %find all indices in doc that have the classification 
        for j = idx(1): idx(length(idx)) %for all indices(implant number)
          Anterior(j,i) = Anterior_Third(j); %fill Anterior with percentile of that implant number in the jth row
          Middle(j,i) = Middle_Third(j); %fill Middle with percentile of that implant number in the jth row
          Posterior(j,i) = Posterior_Third(j); %fill Posterior with percentile of that implant number in the jth row
        end
    end
end

%form empty arrays holding standard deviations for each bar in bar graph
extstd = [];
midstd = [];

   
real_Extremities = [];
for i = 2: length(type_array)  %for all columns except for the first(holds NaN or 0 values)
    Middle_col = Middle(:,i); %fill array with all values in that column
    real_Middle(i) = mean(Middle_col((Middle_col ~= 0))) .* 100; %take average of all values in that column that are not equal to 0(zeros append non-zero values)
    midstd(i) = std(Middle_col((Middle_col ~= 0))) .* 100; %take standard deviation of all values in that column that are not equal to 0(zeros append non-zero values)
    
    Posterior_col = Posterior(:,i); %fill array with all values in that column
    Anterior_col = Anterior(:,i);  %fill array with all values in that column
    
    realpos_col = Posterior_col((Posterior_col ~= 0)); %make array with all values except appending zeros
    realant_col = Anterior_col((Anterior_col ~= 0));  %make array with all values except appending zeros
    
    real_Extremities(i) = (mean(realant_col) + mean(realpos_col)) .*50 ; %find average of concatenated array with anterior and posterior values
    extstd(i) = std([realpos_col ; realant_col]) .* 100;    %find standard deviation of concatenated array with anterior and posterior values
end

hold on;

%set 1st column of each array to blank
real_Extremities(1) = []; 
real_Middle(1) = []; 
extstd(1) = [];
midstd(1) = [];

label_array = []; %contains all labels
value_array = []; %contains all values

for i = 2:length(type_array) 
    current_label = categorical({strcat('Extremities -', type_array(i)) , strcat('Middle- ' , type_array(i))}); %create labels for current subvariable
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
% 
% title('Patient Sex Against Average Difference');
% xlabel('Patient Sex');
% ylabel('Tenth Percentile of Z-values(mm)');
% legend('Female' , 'Male');
% 
% title('Size Against Average Difference');
% xlabel('Size');
% ylabel('Tenth Percentile of Z-values(mm)');
% legend('Size 48' , 'Size 44' , 'Standard' ,'Size 36', 'Size 52');
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
% legend('0 - 2' , '2 - 8' , '8+');  
%
%set y axis limits
ylim([0 20/10]);
hold off;
