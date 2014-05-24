`cw1 - Getting and Cleaning Data`
=================

How Script Works



Steps to reproduce this project

1. Open the R script run_analysis.r using a text editor.
2. Change the parameter of the setwd function call to the working directory/folder (i.e., the folder where these the R script file is saved).
3. Run the R script run_analysis.r. 

Outputs produced

Tidy dataset file tidyDataset.txt & tidyDataset2.txt (tab-delimited text)


Download the file
```r
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("Dataset.zip")) {
    download.file(fileUrl, destfile = "Dataset.zip", method = "wget")
}
```



Unzip the file. 


```r
if (!file.exists("UCI HAR Dataset")) {
    unzip("Dataset.zip", overwrite = TRUE)
}
```


read the file with white-space as delimiter


```r
testDataset <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "", colClasses = "numeric", 
    header = FALSE)
trainDataset <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "", colClasses = "numeric", 
    header = FALSE)
```


Read the features from features.txt

```r
featuresData <- read.csv("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
```


Extract the features vector from featuresData

```r
featuresVector <- featuresData[, 2]
```


Add header to data.frame.


```r
colnames(testDataset) <- featuresVector
colnames(trainDataset) <- featuresVector
```


validate data


```r
# head(testDataset) head(trainDataset)
```


 

Features Vector

```r
testY <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
trainY <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
```


Assign Header


```r
colnames(testY) <- "activityLabel"
colnames(trainY) <- "activityLabel"
```



Activity Label Data

```r
activityLabels <- read.csv("./UCI HAR Dataset//activity_labels.txt", sep = "", 
    header = FALSE)
```




```r
colnames(activityLabels) <- c("activityLabel", "activity")
```


merge activity with labels 

```r
activityTest <- merge(testY, activityLabels)
# head(activityTest)
activityTrain <- merge(trainY, activityLabels)
# head(activityTrain)
```


Add activity data to test and train dataset


```r
testDataset <- cbind(testDataset, activityTest)
trainDataset <- cbind(trainDataset, activityTrain)
```


validate data

```r
# head(testDatasetwithactivity) head(trainDatasetwithactivity)
```




Merge test and train datasets


```r
completeDataset <- rbind(testDataset, trainDataset)
```





Now, lets subset the dataset for mean and std measures only!

Use Grep for identifying the subset measures. 


```r
completeDataset <- subset(completeDataset, select = grepl("mean|std", featuresVector))
```


validate data

```r
# head(completeDataset)
```




```r
write.table(completeDataset, file = "tidyDataset.txt", sep = "\t", row.names = FALSE)
```




```r
subjectTest <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep = "", 
    header = FALSE)
subjectTrain <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep = "", 
    header = FALSE)
colnames(subjectTrain) <- "subject"
colnames(subjectTest) <- "subject"
```




```r
testDataset <- cbind(testDataset, subjectTest)
trainDataset <- cbind(trainDataset, subjectTrain)
```




```r
completeDataset1 <- rbind(testDataset, trainDataset)
```


Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



```r
tidyDataset2 <- aggregate(completeDataset1[, 1:562], completeDataset1[, 563:564], 
    FUN = mean)
```




```r
# head(tidyDataset2)
```


Write this tidy dataset


```r
write.table(tidyDataset2, file = "tidyDataset2.txt", sep = "\t", row.names = FALSE)
```


