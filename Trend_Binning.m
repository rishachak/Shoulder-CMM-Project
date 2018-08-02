%%%Objective: Bin time in vivo and age to aid production of bar graphs
%Author: Risha Chakraborty and Jonah Steuer, 2018

Trend_Setter_Total
Trend_Setter_Reverse

binned_vivo_Total = [];

for i = 1: length(time_in_vivo_Total)
    if time_in_vivo_Total(i) < 24
        binned_vivo_Total = [binned_vivo_Total ; 'A'];
    elseif time_in_vivo_Total(i) < 96
        binned_vivo_Total = [binned_vivo_Total ; 'B'];
    elseif time_in_vivo_Total(i) > 96
        binned_vivo_Total = [binned_vivo_Total ; 'C'];
    else
        binned_vivo_Total = [binned_vivo_Total ; ' '];
    end
end

binned_age_Total = [];

for i = 1: length(patient_age_Total) 
    if patient_age_Total(i) < 30
        binned_age_Total = [binned_age_Total ; 'A'];
    elseif patient_age_Total(i) < 50
        binned_age_Total = [binned_age_Total ; 'B'];
    elseif patient_age_Total(i) < 70
        binned_age_Total = [binned_age_Total ; 'C'];
    elseif patient_age_Total(i) < 90
        binned_age_Total = [binned_age_Total ; 'D'];
    elseif patient_age_Total(i) > 90
        binned_age_Total = [binned_age_Total ; 'E'];
    else 
        binned_age_Total = [binned_age_Total ; ' '];
    end
end

 binned_vivo_Reverse = [];

for i = 1: length(time_in_vivo_Reverse)
    if time_in_vivo_Reverse(i) < 24
        binned_vivo_Reverse = [binned_vivo_Reverse ; 'A'];
    elseif time_in_vivo_Reverse(i) < 96
        binned_vivo_Reverse = [binned_vivo_Reverse ; 'B'];
    elseif time_in_vivo_Reverse(i) > 96
        binned_vivo_Reverse = [binned_vivo_Reverse ; 'C'];
    else
        binned_vivo_Reverse = [binned_vivo_Reverse ; ' '];
    end
end

binned_age_Reverse = [];

for i = 1: length(patient_age_Reverse) 
    if patient_age_Reverse(i) < 30
        binned_age_Reverse = [binned_age_Reverse ; 'A'];
    elseif patient_age_Reverse(i) < 50
        binned_age_Reverse = [binned_age_Reverse ; 'B'];
    elseif patient_age_Reverse(i) < 70
        binned_age_Reverse = [binned_age_Reverse ; 'C'];
    elseif patient_age_Reverse(i) < 90
        binned_age_Reverse = [binned_age_Reverse ; 'D'];
    elseif patient_age_Reverse(i) > 90
        binned_age_Reverse = [binned_age_Reverse ; 'E'];
    else
        binned_age_Reverse = [binned_age_Reverse ; ' '];
    end
end

        