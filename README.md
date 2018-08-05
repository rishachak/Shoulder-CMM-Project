# Shoulder-CMM-Project
All codes for summer 2018 Shoulder CMM Project.

CODES: 

actual_Antpos: graphs average deformation (absolute value of difference of z-values between correct and retrieved implants) of swaths of implant considered from one end to the other along the anterior-posterior axis
*first calculates difference of z-values for all points in a certain region of interest, then takes absolute value and averages
**measurements in mm, x-axis measured in inches originally, convert to mm (*25.4)
***must run realGlobals beforehand to add global variables(axis limits) to workspace; if break is necessary, run program with y-axis limit of maximum z-diff(commented out) ; otherwise default of  0.4 maximum z-diff

actual_Supinf: graphs average deformation (absolute value of difference of z-values between correct and retrieved implants*) of swaths of implant considered from one end to the other along the inferior-superior axis
*first calculates difference of z-values for all points in a certain region of interest, then takes absolute value and averages
**measurements in mm, x-axis measured in inches originally, convert to mm (*25.4)
***must run realGlobals beforehand to add global variables(axis limits) to workspace; if break is necessary, run program with y-axis limit of maximum z-diff(commented out) ; otherwise default of  0.4 maximum z-diff

Manual_Percentile: graphs heat map and specifies top 10th percentile of deformation (calculates 10th percentile using absolute value of differences but flags positive/negative deformation), sends positive deformation above 10th percentile to red and negative deformation above 10th percentile to blue
*sends non-implant region to white color, non-10th percentile implant-region to gray color
**can change top percentile in line 47, change number inputted to prctile function(set at 90)
***difference = retrieved implant – original implant, red means retrieved is above original implant, blue means retrieved is below original implant

ReverseTotal_AntposComparison: graphs average and standard deviation(errorbar) of top 10th percentile of deformation of extremities regions of total implants, middle region of total implants, extremities regions of reverse implants, middle region of reverse implants
*can change extend of extremities region and middle region, options provided for: divided into thirds(anterior(1/3), middle(1/3), and posterior(1/3)), divided into fourths(anterior(1/4), middle(2/4), posterior(1/4))
**extremities matrix formed after concatenation of anterior and posterior matrices, average and standard deviation calculated for this concatenated matrix
***when running choose all_cleaned then all_cleaned_cups 

ReverseTotal_SupinfComparison: graphs average and standard deviation(errorbar) of top 10th percentile of deformation of extremities regions of total implants, middle region of total implants, extremities regions of reverse implants, middle region of reverse implants
*can change extend of extremities region and middle region, options provided for: divided into thirds(inferior(1/3), middle(1/3), and superior(1/3)), divided into fourths(inferior(1/4), middle(2/4), superior(1/4))
**extremities matrix formed after concatenation of inferior and superior matrices, average and standard deviation calculated for this concatenated matrix
***when running choose all_cleaned then all_cleaned_cups 


NOTABSreversetotal_antpos: Compares extremities for 10th percentile of deformation for reverse and total arthroplasties, specifies positive and negative deformation
*Absolute value isn’t taken in order to tell magnitude of deformation for positive and negative deformation
**Scanned along anterior-posterior axis
***When running choose all_cleaned then all_cleaned_cups

NOTABSreversetotal_supinf: Compares extremities for 10th percentile of deformation for reverse and total arthroplasties, specifies positive and negative deformation
*Absolute value isn’t taken in order to tell magnitude of deformation for positive and negative deformation
**Scanned from superior to inferior end
***When running choose all_cleaned then all_cleaned_cups 


Flexy_Divide_Antpos_Bar: Graphs different external factors against 10th percentile of deformation when implant is scanned along anterior-posterior axis. These 3 files contain all data for external factors: Trend_Setter_Total, Trend_Setter_Reverse, Trend_Binning. Set doc variable to the  variable in one of these files that you wish to graph. Depending on which variable you choose you must uncomment the legend and axis labels that correspond to the variable. Then run and choose all_cleaned folder for glenoids or all_cleaned_cups for humeral cups.
Ex graphing of L vs. R: for glenoids: 
1.	Set doc variable to surgery_arm_total
2.	Uncomment section with title(‘Patient Sex Against Average Difference)
3.	Run and select all_cleaned folder 


Flexy_Divide_Supinf_Bar: Graphs different external factors against 10th percentile of deformation when implant is scanned from superor to inferior end. These 3 files contain all data for external factors: Trend_Setter_Total, Trend_Setter_Reverse, Trend_Binning. Set doc variable to the  variable in one of these files that you wish to graph. Depending on which variable you choose you must uncomment the legend and axis labels that correspond to the variable. Then run and choose all_cleaned folder for glenoids or all_cleaned_cups for humeral cups.
Ex graphing of L vs. R: for glenoids: 
1.	Set doc variable to surgery_arm_total
2.	Uncomment section with title(‘Patient Sex Against Average Difference)
3.	Run and select all_cleaned folder 

Trend_Binning: bins time in vivo and patient age, calls Trend_Setter programs, Flexy programs call it
*can change bins by changing parameters in if-else statements

Trend_Setter_Total: contains data (from operative reports) for total implants stored in matrices, data that is not available is replaced by empty character or NaN, for use in other programs (Flexy programs and Trend_Binning already call it)

Trend_Setter_Reverse: contains data (from operative reports) for reverse implants stored in matrices, data that is not available is replaced by empty character or NaN, for use in other programs (Flexy programs and Trend_Binning already call it)

realGlobals: scans all implants and gets minimum and maximum x value, y value, and z-diff for use in other programs (can be directly called or called by other program itself)


FUNCTIONS:

breakyaxis: takes two parameters, breaks y-axis at a specified point(first parameter) and extends break to second parameter

lst_sq_sph_fit: Input deformed implant’s points to get the center and radius of “perfect” sphere.


FOLDERS:

All Heat Maps Glenoid: Contains heat maps for all glenoid implants

All Heat Maps Humeral: Contains heat maps for all humeral cup implants

Supinf Scans Glenoid: Contains all actual_supinf graphs for glenoids

Supinf Scans Humeral: Contains all actual_supinf graphs for humeral cups

Antpos Scans Glenoid: Contains all actual_antpos graphs for glenoids

Antpos Scans Humeral: Contains all actual_antpos graphs for humeral cups

Reverse_Total: Contains all reverse vs. total graphs

External Factor Trends: contains all graphs created from Flexy_Divide_Supinf_Bar and Flexy_Divide_Antpos_Bar for glenoids and humeral cups.

ALL EXCEL SHEETS:

ShoulderDatabase: contains all patient information combed from operative reports

All Patient Data: contains all patient information used within Trend_Setter 

Shoulder Workbook: contains information from initial analyses
