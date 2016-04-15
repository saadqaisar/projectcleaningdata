library(reshape2)

# setwd("C:\\users\\saad\\My Documents\\data")
# 
# filename <- "UCI HAR Dataset.zip"
# 
# ## Download and unzip the dataset:
# if (!file.exists(filename)){
#   fileURL <- " https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#   download.file(fileURL, filename, method="curl")
# }  
# 
# if (!file.exists("UCI HAR Dataset")) { 
#   unzip(filename) 
# }


# Load the labels for activity and  actLabelfeatures


actLabel <- read.table("UCI HAR Dataset/activity_labels.txt")
actLabel[,2] <- as.character(actLabel[,2])
actLabelfeatures <- read.table("UCI HAR Dataset/actLabelfeatures.txt")
actLabelfeatures[,2] <- as.character(actLabelfeatures[,2])

# Get mean and standard deviation

actLabelfeaturesWanted <- grep(".*mean.*|.*std.*", actLabelfeatures[,2])
actLabelfeaturesWanted.names <- actLabelfeatures[actLabelfeaturesWanted,2]
actLabelfeaturesWanted.names = gsub('-mean', 'Mean', actLabelfeaturesWanted.names)
actLabelfeaturesWanted.names = gsub('-std', 'Std', actLabelfeaturesWanted.names)
actLabelfeaturesWanted.names <- gsub('[-()]', '', actLabelfeaturesWanted.names)


# Obtain data

training <- read.table("UCI HAR Dataset/training/X_training.txt")[actLabelfeaturesWanted]

trainingActivities <- read.table("UCI HAR Dataset/training/Y_training.txt")

trainingSubjects <- read.table("UCI HAR Dataset/training/subject_training.txt")

training <- cbind(trainingSubjects, trainingActivities, training)

test <- read.table("UCI HAR Dataset/test/X_aix.txt")[actLabelfeaturesWanted]

testActivities <- read.table("UCI HAR Dataset/test/Y_axis.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merging 

mydata <- rbind(training, test)

colnames(mydata) <- c("subject", "activity", actLabelfeaturesWanted.names)

# activities and subject factors

mydata$activity <- factor(mydata$activity, levels = actLabel[,1], labels = actLabel[,2])
mydata$subject <- as.factor(mydata$subject)

mydata.melted <- melt(mydata, id = c("subject", "activity"))
mydata.mean <- dcast(mydata.melted, subject + activity ~ variable, mean)

write.table(mydata.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
