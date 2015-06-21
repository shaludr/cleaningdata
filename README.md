# cleaningdata
#You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Instructions

#Download the data source from here
Unzip the file and extract the folder UCI HAR Dataset
Set the parent folder of UCI HAR Dataset as your working directory in R
Download run_analysis.R from this repository onto you working directory
Source the 'run_analysis.R' file and its ready for use

#Sample Output
source('run_analysis.R')
myfunctions <- RunAnalysis("UCI HAR Dataset")
myfunctions$writeTidyData("test.txt")
