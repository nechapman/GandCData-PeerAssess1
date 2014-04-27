Codebook for Getting and Cleaning Data - Peer Assessment 1

A decription of the Original Data used can be found at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The Original Data files are sourced from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


The Script "run_analysis.R" manipulates the Original Data to:

1. Import the data sets - 
	There are two data sets within the Original Data. Assuming the default unzipped directory of "UCI HAR Dataset" the "test" and "train" folders contain:
	i. 	subject_<folder name> - contains a list of subject #s for each data entry
	ii.	y_<folder name> - contains an activity number
	iii.	X_<folder name> - contains feature data
These three files are combined for each folder, respectively, to create complete "test" and "train" data sets of the form:
	Subject, Activity, Feature Data columns
The "Inertial Signals" subfolders from the Original Data are not required.

2. Merge the data sets - 
	The two data sets created in step 1, "test_set" and "train_set" are combined, using the Original "features.txt" to create the Feature Data column headings. The result is a "combined_set" data frame. This completes the first goal of the assignment.

3. Identify and Extract the Mean and STD columns -
	The second objective is to extract the measurements from the Original Data which are either "means" or "standard deviations". The script uses a package called "stringr" to extract only the columns with the Original Data labels "mean(" and "std(" in their headings. N.B. This deliberately omits the undesired "meanFreq" readings. A full list of the Mean and STD variable names is available at the end of this description, in ANNEX A. The non-matching Feature Data is not included in the result, the "trimmed_set".

4. Describe the Activities by name - 
	The Original "activity_labels.txt" file is read in and used to correlate the "Activity" (number) column in the "trimmed_set" with the text description of the activity. See ANNEX B for the translation. An extra column is added to the "trimmed_set", to give the "activitynamed_set" with form:
	Subject, Activity, Activity_Title, Feature Data columns

5. Create the averages and tidy set -
	Using the "reshape2" package the "activitynamed_set" is reshaped to be ordered by Subject (1-30) and Activity Number (1-6)/Name[see ANNEX B] pairs with the values of the remaining entries being averaged (by mean). 

e.g.
Subject	Activity	Activity Name 	   tBodyAcc-mean()-X 	...

1		1		WALKING		   0.2773308		...

1		2		WALKING_UPSTAIRS	   0.2554617		...

...		...		...			   ...			...

30        	6   	     	LAYING             0.2810339		...

The final data set is called "tidy_set" and is written to an output file "tidy_set.txt".


ANNEX A:
-------
 
The complete list of variable names which were either Mean or Standard Deviation are:
           
 "tBodyAcc-mean()-X"                "tBodyAcc-mean()-Y"          
 "tBodyAcc-mean()-Z"                "tBodyAcc-std()-X"           
 "tBodyAcc-std()-Y"                 "tBodyAcc-std()-Z"           
 "tGravityAcc-mean()-X"             "tGravityAcc-mean()-Y"       
 "tGravityAcc-mean()-Z"             "tGravityAcc-std()-X"        
 "tGravityAcc-std()-Y"              "tGravityAcc-std()-Z"        
 "tBodyAccJerk-mean()-X"            "tBodyAccJerk-mean()-Y"      
 "tBodyAccJerk-mean()-Z"            "tBodyAccJerk-std()-X"       
 "tBodyAccJerk-std()-Y"             "tBodyAccJerk-std()-Z"       
 "tBodyGyro-mean()-X"               "tBodyGyro-mean()-Y"         
 "tBodyGyro-mean()-Z"               "tBodyGyro-std()-X"          
 "tBodyGyro-std()-Y"                "tBodyGyro-std()-Z"          
 "tBodyGyroJerk-mean()-X"           "tBodyGyroJerk-mean()-Y"     
 "tBodyGyroJerk-mean()-Z"           "tBodyGyroJerk-std()-X"      
 "tBodyGyroJerk-std()-Y"            "tBodyGyroJerk-std()-Z"      
 "tBodyAccMag-mean()"               "tBodyAccMag-std()"          
 "tGravityAccMag-mean()"            "tGravityAccMag-std()"       
 "tBodyAccJerkMag-mean()"           "tBodyAccJerkMag-std()"      
 "tBodyGyroMag-mean()"              "tBodyGyroMag-std()"         
 "tBodyGyroJerkMag-mean()"          "tBodyGyroJerkMag-std()"     
 "fBodyAcc-mean()-X"                "fBodyAcc-mean()-Y"          
 "fBodyAcc-mean()-Z"               "fBodyAcc-std()-X"           
 "fBodyAcc-std()-Y"                 "fBodyAcc-std()-Z"           
 "fBodyAccJerk-mean()-X"            "fBodyAccJerk-mean()-Y"      
 "fBodyAccJerk-mean()-Z"            "fBodyAccJerk-std()-X"       
 "fBodyAccJerk-std()-Y"             "fBodyAccJerk-std()-Z"       
 "fBodyGyro-mean()-X"               "fBodyGyro-mean()-Y"         
 "fBodyGyro-mean()-Z"               "fBodyGyro-std()-X"          
 "fBodyGyro-std()-Y"                "fBodyGyro-std()-Z"          
 "fBodyAccMag-mean()"               "fBodyAccMag-std()"          
 "fBodyBodyAccJerkMag-mean()"       "fBodyBodyAccJerkMag-std()"  
 "fBodyBodyGyroMag-mean()"          "fBodyBodyGyroMag-std()"     
 "fBodyBodyGyroJerkMag-mean()"      "fBodyBodyGyroJerkMag-std()" 

These feature as columns 3-68 in "trimmed_set", 4-69 in "activitynamed_set" and are the basis for the mean values created for 4-69 of the final "tidy_set"

ANNEX B:
-------
Activity Number		Activity Name

	1			WALKING
	
	2			WALKING_UPSTAIRS
	
	3			WALKING_DOWNSTAIRS
	
	4			SITTING
	
	5			STANDING
	
	6			LAYING
