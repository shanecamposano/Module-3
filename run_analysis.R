## Module 3 : Getting and Cleaning Data (Using Windows Platform)

## Create a folder and download the file using the url provided
if(!file.exists("data")){dir.create("data")}
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile="data\\assignment.zip")


## Since the downloaded file is compressed, unzip it
unzip(zipfile="data\\assignment.zip", exdir="data")

## Read and load files of unzipped UCI HAR Dataset into R
  test.act <- read.table("data\\UCI HAR Dataset\\test\\Y_test.txt")
  train.act <- read.table("data\\UCI HAR Dataset\\train\\Y_train.txt")
  
  test.feat <- read.table("data\\UCI HAR Dataset\\test\\X_test.txt")
  train.feat <- read.table("data\\UCI HAR Dataset\\train\\X_train.txt")
  
  test.sub <- read.table("data\\UCI HAR Dataset\\test\\subject_test.txt")
  train.sub <- read.table("data\\UCI HAR Dataset\\train\\subject_train.txt")
  

## Merge the test set and train set into one dataset & set names to variables
  Subject <- rbind(train.sub,test.sub)
  Activity <- rbind(train.act, test.act)
  Feature <- rbind(train.feat, test.feat)
  
  FeatureName <-read.table("data\\UCI HAR Dataset\\features.txt")
  names(Feature)<- FeatureName$V2
  names(Subject) <- c("Subject")
  names(Activity) <- c("Activity")
  
## Column bind to obtain a data frame
  fuse <- cbind(Feature, Subject, Activity)
  
## Extract the mean and standard deviation by subsetting the names of feature 
## then subset the merged data 
  subset.Feature <- FeatureName$V2[grep("mean\\(\\)|std\\(\\)", FeatureName$V2)]
  select.names <- c(as.character(subset.Feature), "Subject", "Activity")
  fuse <- subset(fuse,select=select.names)
  
## Use activity labes to name the activities
  act.label <- read.table("data\\UCI HAR Dataset\\activity_labels.txt")
  fuse$Activity<- factor(fuse$Activity,labels = as.character(act.label$V2))

## Label dataset using descriptive and human readable variable names
  names(fuse)<-gsub("^t", "Time", names(fuse))
  names(fuse)<-gsub("^t", "time", names(fuse))
  names(fuse)<-gsub("^f", "frequency", names(fuse))
  names(fuse)<-gsub("Acc", "accelerometer", names(fuse))
  names(fuse)<-gsub("Gyro", "gyroscope", names(fuse))
  names(fuse)<-gsub("Mag", "magnitude", names(fuse))
  names(fuse)<-gsub("BodyBody", "body", names(fuse))
  

## Create a second, independent tidy data set with the average 
## of each variable for each activity and each subject.
  fuse2 <-aggregate(. ~Subject + Activity, fuse, mean)
  fuse2<- fuse2[order(fuse2$Subject,fuse2$Activity),]
  write.table(fuse2, file = "data\\tidydata.txt",row.name=FALSE)
  

  
  