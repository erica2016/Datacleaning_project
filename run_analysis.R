# date: 3/25/2017
#Programmer: Erica2016
# Goal: as data cleaning final project, to clean a few data sets from web, presents it with tidy data 

# step1: download and unzip data 
if(!file.exists("./data")){dir.create("./data")}
urlnew="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(urlnew, destfile = "./data/Dataset.zip", method="curl")

if (!file.exists("UCI HAR Dataset")) { 
   unzip(zipfile="./data/Dataset.zip",exdir="./data")
}

#step2: read downloaded file
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
labels[,2]<-as.character(lables[,2])

# step3:Extracts only the measurements on the mean and standard deviation for each measurement
featuresFilter<-grep("[Mm]ean|[Ss]td",features[,2])
featuresFilterName<-features[featuresFilter,2]
featuresFilterName<-gsub("[-()]","",featuresFilterName)

#step4: merge training and test data into one file
# read training data
trainx <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[featuresFilter]
trainy <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train<-cbind(trainSubject,trainy,trainx)
# read test data
testx <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[featuresFilter]
testy <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test<-cbind(testSubject,testy,testx)
#merge into one file
DataAll<-rbind(train,test)
colnames(DataAll)<-c("subject","activity",featuresFilterName)

#step5: step5: from merged data file, creates a second, independent tidy data set 
#...with the average of each variable for each activity and each subject
#change DataAll activity and subject to factors so that statistics can be applied
DataAll$activity<- factor(DataAll$activity, levels = labels[,1], labels = labels[,2])
DataAll$subject <- as.factor(DataAll$subject)

library(reshape)
DataMelt<-melt(DataAll,id = c("subject", "activity"))
DataMean<-cast(DataMelt, subject + activity ~ variable, mean)

# write DataMean into a tidy document 
write.table(DataMean, "./data/tidy_data.txt", row.name=FALSE)




