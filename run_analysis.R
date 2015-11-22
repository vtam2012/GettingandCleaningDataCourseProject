#You should create one R script called run_analysis.R that does the following. 
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#Download and unzip file
URL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip", exdir = ".")
DIR<- file.path("." , "UCI HAR Dataset")
Files<-list.files(DIR, recursive=TRUE)

#add requiredd libraries
library(plyr)

#read in required files
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#create small data tables that combine trains and tests accordingly
subject_dat <- rbind(subject_train, subject_test)
y_dat<- rbind(y_train, y_test)
X_dat<- rbind(X_train, X_test)

#name each column
names(subject_dat)<-"subject"
names(y_dat)<- "activity"
feature_names <- read.table("./UCI HAR Dataset/features.txt")[,2]
names(X_dat)<-feature_names

#combine the small data tables into one single large table
AllDat <- cbind(subject_dat, y_dat)
AllDat <- cbind(X_dat, AllDat)

#subset the data for mean and standard deviation
SubDatFeatureNames<-feature_names[grep("mean|std", feature_names)]
wantedNames<-c(as.character(SubDatFeatureNames), "subject", "activity" )
AllDat<-subset(AllDat,select= wantedNames)

#rename
factorAllDat<-factor(AllDat$activity)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
levels(factorAllDat)[1]<-levels(activity_labels)[1]
levels(factorAllDat)[2]<-levels(activity_labels)[2]
levels(factorAllDat)[3]<-levels(activity_labels)[3]
levels(factorAllDat)[4]<-levels(activity_labels)[4]
levels(factorAllDat)[5]<-levels(activity_labels)[5]
levels(factorAllDat)[6]<-levels(activity_labels)[6]
AllDat$activity<-factorAllDat

#get mean for each column except subject and activity
TidyDat<-aggregate(. ~subject + activity, AllDat, mean)

#sort the data set based on subject and activity 
TidyDat<-TidyDat[order(TidyDat$subject,TidyDat$activity),]
write.table(TidyDat, file = "tidydata.txt",row.name=FALSE)

