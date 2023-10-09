# Getting-and-Manipulating-data
Contains codes and data for the Getting and Cleaning data sub-course of the 10 module John Hopkins schools Data science Course.
Getting and Cleaning Data Course Project
less
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example
this article
. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#Task

create one R script called run_analysis.R that does the following

Merges the training and the test sets to create one data set.

Extracts only the measurements on the mean and standard deviation for each measurement.

Uses descriptive activity names to name the activities in the data set

Appropriately labels the data set with descriptive variable names.

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



#Solution

###Loading required packages
library(tidyr)
library(dplyr)
library(lubridate)
library(plyr)
library(readxl)

##getting data from the web
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##Extract the data from the zip into a folder labelled "UCI HAR Dataset" in your desired working directory



#Merges the training and the test sets to create one data set.
Create data frames for training data
x_train <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/train/X_train.txt")), stringsAsFactors = FALSE)
colnames(x_train) <- "Measurements"
y_train <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/train/y_train.txt")))
colnames(y_train) <- "Activity label"
subject_train <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/train/subject_train.txt")))
colnames(subject_train) <- "Subject"

#Create data frames for test data
x_test <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/test/X_test.txt")), stringsAsFactors = FALSE)
colnames(x_test) <- "Measurements"
y_test <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/test/y_test.txt")))
colnames(y_test) <- "Activity label"
subject_test <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/test/subject_test.txt")))
colnames(subject_test) <- "Subject"

#Merge datasets
X_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
subject_total <- rbind(subject_train, subject_test)

#Extracts only the measurements on the mean and standard deviation for each
measurement.
1. Go through the features.txt, create a vector that contains the indecies of
mean and std
features <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/features.txt")), stringsAsFactors = FALSE)
colnames(features) <- "Feature"
meanStdFeatures <- grep("mean|std", features$Feature)

2. Apply this filter to the dataframe to extract only the features required
Convert X_total values from characters to a vector - use split fn? strsplit?
Limit to head for the time being
sepMeasurements <- sapply(X_total$Measurements, function(elem) strsplit(elem, " ")) # Returns a list of character vectors
sepMeasurements <- lapply(sepMeasurements, function(elem) as.numeric(elem)) # Convert resulting vectors into numerics
sepMeasurements <- lapply(sepMeasurements, function(elem) elem[complete.cases(elem)]) # Filter on complete cases
sepMeasurements <- lapply(sepMeasurements, function(elem) elem[meanStdFeatures]) # And only keep the elements whose index matches those in meanStdFeatures

Uses descriptive activity names to name the activities in the data set
Get data from activity_labels.txt
Change y_total
activitiesDF <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/activity_labels.txt")), stringsAsFactors = FALSE)
activitiesVec <- as.data.frame(sapply(strsplit(activitiesDF[,1], " "), function(elem) return(elem[2])))
activitiesVec <- cbind(1:6, activitiesVec)
colnames(activitiesVec) <- c("Activity label", "activitydesc")
descriptiveactivitynames <- merge(y_total, activitiesVec, by = "Activity label")
total_X <- cbind(descriptiveactivitynames$activitydesc, X_total)
colnames(total_X) <- c("desc", "measurement")

Appropriately labels the data set with descriptive variable names. Add labels
to each vector that contains mesurements. Get this from "features.txt"
featuresDF <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/features.txt")), stringsAsFactors = FALSE)
featuresVec <- as.data.frame(sapply(strsplit(features[,1], " "), function(elem) return(elem[2])))
featuresVec <- cbind(1:561, featuresVec)
colnames(featuresVec) <- c("featureindex", "featuredesc")

#Creates a second, independent tidy data set with the average of each variable
#for each activity and each subject.


#NOTES
We have three files -
1. X_train.txt - each line contains 561 measurements from various sensors
subject_train.txt - each line contains one number to ID the subject from 1-30
1 3 5 6 7 8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30
2.There are 21 unique numbers in the training set, 9 in the test
y_train.txt - lists activity for each row
1 WALKING 2 WALKING_UPSTAIRS 3 WALKING_DOWNSTAIRS 4 SITTING 5 STANDING 6
LAYING
3. Subject - int, Activity - int, Vector of measurements - 561 elements
