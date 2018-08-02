%%%%for reference use
% patient_ids=[201,209,210,212,219,231,232,234,241,260,261,263,264,267,271,272,275,284,285,286,287,288,290,291,310,311,312,313,314,315];
%real_patient_ids = [201,209,210,212,219,231,232,234,241,243,260,261,262,263,264,267,271,272,275,282,283,284,285,286,287,288,290,291,292,310,311,312,313,314,315];

time_in_vivo_Reverse=[NaN,46,43,4,13,10,92,49,14,NaN,3,0,NaN,24,25,3,19,112,30,NaN,NaN,9,10,1,0,2,6,12,NaN,109,38,106,13,NaN,8];
patient_age_Reverse =[NaN,68,54,56,53,55,74,65,62,NaN,57,37,NaN,53,63,66,77,59,51,NaN,NaN,62,54,65,69,67,65,66,NaN,76,69,60,69,NaN,62];
patient_sex_Reverse = [' ','f','m','f','f','m','m','f','m',' ','m','m',' ','m','m','f','f','m','m',' ',' ','m','m','m','m','m','f','m',' ','m','f','m','f',' ','m'];
patient_arm_Reverse = [' ','L','L','R','R','R','L','R','L',' ','L','R',' ','R','R','R','R','L','R',' ',' ','R','R','L','R','R','R','R',' ','R','R','R','L',' ','R'];

%D = Depuy Delta XTend
%A = Tornier Aquelis
%F = Tornier Aquelis FX
%I = Tornier Aquelis II/FX
%T = Tornier


time_in_vivo_Reverse = transpose(time_in_vivo_Reverse);
patient_age_Reverse = transpose(patient_age_Reverse);
patient_sex_Reverse = transpose(patient_sex_Reverse);
patient_arm_Reverse = transpose(patient_arm_Reverse);




% fileID = fopen('time_in_vivo.txt','w');
% fprintf = (fileID, A);
% fclose(fileID);
