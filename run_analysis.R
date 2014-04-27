## Getting and Cleaning Data - Peer Assessment 1

## "You should create one R script called run_analysis.R that does the following. 
## A. Merges the training and the test sets to create one data set.
## B. Extracts only the measurements on the mean and standard deviation for each measurement. 
## C. Uses descriptive activity names to name the activities in the data set
## D. Appropriately labels the data set with descriptive activity names. 
## E. Creates a second, independent tidy data set with the average of each variable for each activity and each subject."


## Step 0 - Acquire the data set:
##-------------------------------
## Assume data set is already downloaded, in the current working directory and uses the default name
## If assumption is false, throws a warning about missing file. Can use next two lines of commented code to download file

#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url=fileUrl,destfile="getdata_projectfiles_UCI HAR Dataset.zip")
if (file.exists("getdata_projectfiles_UCI HAR Dataset.zip") == FALSE){
    print("'getdata_projectfiles_UCI HAR Dataset.zip' does not exist in current working directory - see Script for download.file command")
    stop
} 

## Check if data set has already been extracted by looking for the \UCI HAR Dataset\README.txt file
## If it doesn't - unzip the (existing) zip file
if (file.exists("UCI HAR Dataset/README.txt") == FALSE){
    unzip(zipfile="getdata_projectfiles_UCI HAR Dataset.zip")
}


## Step 1 - Import the data sets:
##-------------------------------

## Create complete "test" set for merging
## Import Subject Number from "subject_test.txt" (as a Data Frame)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
## import Activity Number from "y_test.txt"
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
## import Feature Data from "X_test.txt" 
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
## Combine to form a data table with Subject, Activity Number, Feature Data columns
test_set <- cbind(subject_test,y_test,X_test)

## Create complete "training" set for merging
## Import Subject Number from "subject_train.txt" 
subject_train <- read.table(file="UCI HAR Dataset/train/subject_train.txt")
## Import Activity Number from "y_train.txt"
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
## Import Feature Data from "X_train.txt" 
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
## Combine to form a data table with Subject, Activity Number, Feature Data columns
train_set <- cbind(subject_train,y_train,X_train)


## Step 2 - Merge the data sets:
##------------------------------

## Import Feature Headings from "features.txt"
feature_headings <- read.table("UCI HAR Dataset/features.txt")
## Create a full set of headings to fit over the format of Subject, Activity Number, Feature Data columns
data_headings <- c("Subject", "Activity", as.character(feature_headings[,2]))

## As there are no shared Ids merge test and training sets with Row bind
combined_set <- data.frame(rbind(test_set,train_set))
## Add the created heading text as the combined data set column names
colnames(combined_set) <- data_headings

## ==================================================================
## A. "Merges the training and the test sets to create one data set."
## A. is now complete, "combined_set" is the one data set requested.
## ==================================================================


## Step 3 - Identify and Extract the Mean and STD columns:
##--------------------------------------------------------

## Identify which columns use the "mean(" or "std(" strings in them, using the "stringr" package
#install.packages("stringr")
#library(stringr)
require(stringr)
## Create a logical with TRUE if "mean(" OR "-std(" in the heading (strings taken from examination of features.txt and features_info.txt)
meanorstd <- str_detect(as.character(data_headings), "mean\\(") | str_detect(as.character(data_headings), "std\\(")

## Identify which entries are TRUE
meanorstd_cols <- which(meanorstd)

## Trim the data set to include only the Subject, Activity and the columns identified as either Mean or Std
trimmed_set <- cbind(combined_set[,1:2],combined_set[,meanorstd_cols])

## ==========================================================================================
## B. Extracts only the measurements on the mean and standard deviation for each measurement. 
## B. is now complete, the "trimmed_set" contains only the names and extracted Mean/Std cols
## ==========================================================================================


## Step 4 - Describe the Activities by name:
##-------------------------------------------

## Import the Activity Names from the "activity_labels.txt"
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
## Create a new Activity Label column using:
##      i.  Activity column in combined_set
##      ii. Factor reference numbers (levels) from the first column in activity_labels
##      iii.Factor reference names (labels) from the second column in activity_labels
activity_label_col <- data.frame(factor(trimmed_set$Activity, levels=activity_labels[,1],labels=activity_labels[,2]))
colnames(activity_label_col) <- "Activity_Name"

## N.B. I'm creating a new column as the instructions are ambigious about whether to Replace the Activity Numbers or not
## you could replace the existing column instead using:
##      combined_set$Activity <- factor(combined_set1$Activity, levels=activity_labels[,1],labels=activity_labels[,2])
## This command would break some of the following script - as the presence of Activity and Activity_Name are assumed

## Add the Activity_Name column into the combined set (next to the Activity number)
activitynamed_set <- data.frame(trimmed_set[,1:2],activity_label_col,trimmed_set[,3:ncol(trimmed_set)])

## =========================================================================
## C. Uses descriptive activity names to name the activities in the data set
## D. Appropriately labels the data set with descriptive activity names. 
## C. & D. are now complete - the names have been taken from the files and 
## now appear as a labeled columns, including the extra column 
## Activity_Name, in the "activitynamed_set"
## =========================================================================


## Step 5 - Create the averages and tidy set:
##-------------------------------------------

require(reshape2)
## Melt the data set (as per Reshaping Data lecture)
melted_set <- melt(activitynamed_set,id = c("Subject", "Activity", "Activity_Name"))

## Recast the data, with the Id columns as "Subject", "Activity", "Activity_Name" and compute Mean of all other entries
tidy_set <- dcast(melted_set, formula = Subject + Activity + Activity_Name ~ variable, mean)
## Output the tidy data set as a text file, for upload
write.table(tidy_set,"tidy_set.txt",row.names=FALSE)

## =====================================================================================================================
## E. Creates a second, independent tidy data set with the average of each variable for each activity and each subject."
## E. is now complete - the tidy_set has one row for each Subject + Activity/Activity Name combination along with
## computed averages (mean) of all other Feature data.
## =====================================================================================================================


