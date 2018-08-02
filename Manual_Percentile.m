%%%Objective: create heat map of implant specifying top tenth percentile of
%%%deformation and coloring positive deformation red and negative
%%%deformation blue
%Author: Risha Chakraborty and Jonah Steuer, 2018
clc; clear all; close all;

%%%% OPTION TO CHOOSE A SINGLE FILE
[FileName,PathName] = uigetfile('*.*');
file = sprintf('%s%s',PathName,FileName);
coord=importdata(file);
%%%%%
x = coord(:,1); y = coord(:,2); z = coord(:,3);

% call least-squares spherical fit function with the deformed implant's points(consider entire implant) to get center and radius of original implant
[center,radius,residuals] = lst_sq_sph_fit(coord(:, 1),coord(: , 2),coord(: , 3)); 

%initialize array that will hold the z values of perfect implant
correct_coord(:, 1:2) = coord(:,1:2);

%plug in x and y coords into general sphere equation(using the previously calculated center and radius)
%to create z values and fill in correct_coord
for i = 1: length(x)
   correct_coord(i,3) = -sqrt(radius^2 - (coord(i, 1) - center(1)).^2 - (coord(i,2)-center(2)).^2) + center(3);
end

%%% normalize to origin, convert to integer
xmin = min(coord(:,1)); ymin = min(coord(:,2));

coordc(:,1) = coord(:,1) - xmin; 
coordc(:,2) = coord(:,2) - ymin;

coordc = round((coordc ./ 0.01 )) + 1 ; % convert x,y location to integers
coordc(:,3) = coord(:,3); 

coordcc = round((correct_coord ./ 0.01)) + 1; % convert x,y location to integers
coordcc(:,3) = correct_coord(:,3);

difference = zeros(length(coord),4); % initialize difference vector
difference(:,1:2) = coordc(:,1:2);  % x,y coordinates remain the same
difference(:,3) = coordc(:,3) - coordcc(:,3); % z coordinate = difference between implant and control

for i = 1:length(difference) %%%for all differences
    if difference(i,3) > 0 %%%if the difference is positive
       difference(i,4) = 1; %%%assign a flag of 1
    end %otherwise, flag remains 0 
end

difference = abs(difference); %%%take absolute value of differences

difference = sortrows(difference,3);  %%%sort differences numerically
percentile = prctile(difference(:,3), [90]); % calculate 90th percentile
 
color_number = zeros(length(coord),3); %intitalize color number
color_number(:,1:2) = difference(:,1:2);  %%%color number first two columns = difference first two columns
for i = 1:length(difference) %set values in color number depending on positive/negative
     if difference(i,3) >= percentile(1) && difference(i,4) == 1 %%%if the difference is greater than 10th percentile and positive
         color_number(i,3) = 1;  %%%assign a color number of 1
     elseif difference(i,3) >= percentile(1) && difference(i,4) == 0  %%%if the difference is greater than 10th percentile and negative
         color_number(i,3) = -1; %%%assign a color number of -1
     else %%%for all implant points not within top 10 percentile
         color_number(i,3) = .01; %%%assign arbitrary color number 0.01 between 1 and -1
     end
 end
 
xmax = max(difference(:,1)); ymax = max(difference(:,2)); % used to define picture extent
pic = zeros(ymax,xmax);

for k = 1:length(coord) %set pic with index based on difference equal to color number
             i = difference(k,1);
             j = difference(k,2);
             pic(j,i) = color_number(k,3);
end


nn = 101;
cbar = zeros(nn,3); %initialize colorbar 
cbar(1,:) = [1 0 0];
%create color bar with red, blue, gray, and white
cbar(2:50, 1) = linspace(0.5,0.5,49);cbar(2:50, 2) = linspace(0.5,0.5,49);cbar(2:50, 3) = linspace(0.5,0.5,49);
cbar(51,:) = [1 1 1];
cbar(52:100, 1) = linspace(0.5,0.5,49);cbar(52:100, 2) = linspace(0.5,0.5,49);cbar(52:100, 3) = linspace(0.5,0.5,49);
cbar(101,:) = [0 0 1];
cbar = flip(cbar);

imagesc(pic); caxis([-1 1]); colormap(cbar); colorbar; axis equal;

axis([-10 180 -10 150]); %set axis

