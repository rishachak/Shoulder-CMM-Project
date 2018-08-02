%%%%for reference use
% patient_ids=[44,46,47,49,59,61,67,71,77,78,79,80,100,104,226,239,247,248,249,255,2701, 277,293,294,299,301,308,140,1501,1502,151, 1601, 1602, KIIC1, KIIC2, KIIC_3, KIIC_4, KIIC_5]
time_in_vivo_Total=           [72,149,55,138,11,168,27,99,111,18,170,181,112,111,44,77,14,9,18,16,278,214,6,7,76,238,10,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN];
patient_age_Total =           [53,60,77,62,73,60,72,68,66,72,72,38,56,53,60,56,42,53,63,62,80,61,53,75,65,51,56,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN];
patient_sex_Total =           ['f','m','m','m','m','m','f','m','m','f','m','m','m','m','f','m','m','m','m','f','f','f','f','m','m','m','m',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '];
surgery_arm_Total = ['r','l','r','r','l','r','r','l','l','r','r','r','l','l','l','l','r','r','l','r','l','l','r','r','r','r','l',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '];
type_of_polyethylene_Total = ['H','C','H','C','C','H','H','H','C','C','C','H','H','X','X','X','X','X', ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '];
size_Total = ['M','S','L','S','X','S','L','L','L','L','S','S','L','L','M','M','M','M','L','T',' ',' ','T',' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '];
%t = 36
% m = 44
% l = 48
% s = std
% x = 52

time_in_vivo_Total= transpose(time_in_vivo_Total);  
patient_age_Total = transpose(patient_age_Total);
patient_sex_Total = transpose(patient_sex_Total);
surgery_arm_Total = transpose(surgery_arm_Total);
type_of_polyethylene_Total = transpose(type_of_polyethylene_Total);
size_Total = transpose(size_Total);


% fileID = fopen('time_in_vivo.txt','w');
% fprintf = (fileID, A);
% fclose(fileID);