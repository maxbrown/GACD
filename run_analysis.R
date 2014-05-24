#Change the parameter of the setwd function call to the working directory
#Setwd("")

#Download the zip file and store in a variable.

fileUrl  <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("Dataset.zip")) {download.file(fileUrl, destfile="Dataset.zip")}

if(!file.exists("UCI HAR Dataset")) {unzip('Dataset.zip', overwrite=TRUE)}

testDataset  <- read.csv('./UCI HAR Dataset/test/X_test.txt',sep="",colClasses="numeric", header=FALSE)
trainDataset  <- read.csv('./UCI HAR Dataset/train/X_train.txt',sep="",colClasses="numeric", header=FALSE)

#Read the features from features.txt
featuresData  <- read.csv('./UCI HAR Dataset/features.txt', sep="", header=FALSE)

#Extract the features vector from featuresData
featuresVector  <- featuresData[,2]

# Add header to data.frame. 
colnames(testDataset)  <- featuresVector
colnames(trainDataset)  <- featuresVector

# Does the data look correct?
head(testDataset)
head(trainDataset)



 

#Declare Features Vector varaiables
testY  <- read.csv('./UCI HAR Dataset/test/y_test.txt',sep="",header=FALSE)
trainY  <- read.csv('./UCI HAR Dataset/train/y_train.txt',sep="",header=FALSE)

# Header

colnames(testY)  <- 'activityLabel'
colnames(trainY)  <- 'activityLabel'

#Activity Label 
activityLabels  <- read.csv('./UCI HAR Dataset//activity_labels.txt',sep="",header=FALSE)

colnames(activityLabels)  <- c('activityLabel','activity')

#merge activity with labels 
activityTest  <- merge(testY, activityLabels)
#head(activityTest)
activityTrain  <- merge(trainY, activityLabels)
#head(activityTrain)

#Add activity data to test and train dataset

testDataset  <- cbind(testDataset, activityTest)
trainDataset  <- cbind(trainDataset, activityTrain)

#Valaidate sample data
head(testDataset)
head(trainDataset)

#Merge test and train datasets

completeDataset  <- rbind(testDataset, trainDataset)


#subset the dataset for mean and std measures using Grep for identifying the subset measures. 

completeDataset  <- subset(completeDataset,select = grepl("mean|std",featuresVector))

#Validate
head(completeDataset)

write.table(completeDataset, file="tidyDataset.txt",sep='\t',row.names=FALSE)


subjectTest  <- read.csv('./UCI HAR Dataset/test/subject_test.txt', sep="", header=FALSE)
subjectTrain  <- read.csv('./UCI HAR Dataset/train/subject_train.txt', sep="", header=FALSE)
colnames(subjectTrain)  <- "subject"
colnames(subjectTest)  <- "subject"

testDataset  <- cbind(testDataset, subjectTest)
trainDataset  <- cbind(trainDataset, subjectTrain)

completeDataset1  <- rbind(testDataset, trainDataset)

#Creates the independent tidy data set with the average of each variable for each activity and each subject. 

tidyDataset2  <- aggregate( completeDataset1[,1:562], completeDataset1[,563:564], FUN = mean )

#Validate
head(tidyDataset2)

#Write this tidy dataset
write.table(tidyDataset2, file="tidyDataset2.txt", sep="\t", row.names=FALSE)
