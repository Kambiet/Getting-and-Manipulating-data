# Getting-and-Manipulating-data
Contains codes and data for the Getting and Cleaning data sub-course of the 10 module John Hopkins schools Data science Course.
run_analysis <- function() {

Merges the training and the test sets to create one data set.
Create data frames for training data
x_train <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/train/X_train.txt")), stringsAsFactors = FALSE)
colnames(x_train) <- "Measurements"
y_train <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/train/y_train.txt")))
colnames(y_train) <- "Activity label"
subject_train <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/train/subject_train.txt")))
colnames(subject_train) <- "Subject"

Create data frames for test data
x_test <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/test/X_test.txt")), stringsAsFactors = FALSE)
colnames(x_test) <- "Measurements"
y_test <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/test/y_test.txt")))
colnames(y_test) <- "Activity label"
subject_test <- as.data.frame(readLines(paste0(getwd(),"/","UCI HAR Dataset/test/subject_test.txt")))
colnames(subject_test) <- "Subject"

Merge datasets
X_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
subject_total <- rbind(subject_train, subject_test)

Extracts only the measurements on the mean and standard deviation for each
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

}
