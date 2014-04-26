# run_analysis.R
# This script reads in motion sensor data from Samsung Galaxy S II smartphones, collected
# by the University of California, Irvine Machine Learning Institute. The data is used
# to classify human activity:

# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# The data can be obtained from the following file:

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# When the data is unzipped, the working directory should be set to the directory that
# gets created, named "UCI HAR Dataset"

# This is not the most efficient way to load the data, but the fread function which is
# part of the data.table library was failing. The data.table structures would also be
# more efficient for any calculations, but the difference is hardly noticeable on a
# modern laptop running Windows - and the small gain in time was not worth the increased
# complexity of the code

# First extract the data column names

Xnames <- as.vector(read.table("features.txt")[,2])


# Read training and test data into data frames, adding activity and subject columns,
# and then combine them and clean up the individual parts

trainX <- read.table("train/X_train.txt")
colnames(trainX) <- Xnames
trainact <- read.table("train/Y_train.txt")
colnames(trainact)[1] <- 'activity'
trainsub <- read.table("train/subject_train.txt")
colnames(trainsub)[1] <- 'subject'
trainX <- data.frame(trainact,trainsub,trainX)

testX <- read.table("test/X_test.txt")
colnames(testX) <- Xnames
testact <- read.table("test/Y_test.txt")
colnames(testact) <- 'activity'
testsub <- read.table("test/subject_test.txt")
colnames(testsub) <- 'subject'
testX <- data.frame(testact,testsub,testX)

allX <- rbind(trainX,testX)
rm(testX,trainX,testact,trainact,testsub,trainsub)


# Add activity and subject lables to the names vector, then determine all columns
# with means and standard deviations. This code will not keep the data from signal
# averaged values (those that contain "Mean" in the name but not "-mean()" ). The
# data frame "trimX" will contain only the desired mean and standard deviation data.

Xnames <- c("activity","subject",Xnames)

usecol <- grepl("-mean\\(|-std\\(",Xnames)
usecol[1:2] <- TRUE

trimX <- allX[usecol]
rm(allX)


# Add in descriptive activity labels, by making them factors. The highly original
# title of "description" will be used as a column name

actdesc <- read.table("activity_labels.txt")
colnames(actdesc) <- c("activity","description")
descriptions = actdesc$description
names(descriptions) = actdesc$activity
descX <- as.character(descriptions[trimX$activity])
trimX <- data.frame(descX,trimX)
colnames(trimX)[1] <- "description"


# The aggregate function is an efficient mechanism to group the data by activity, description,
# and subject, with the average of each other column. In order not to calculate the average of
# the labels themselves, the code is taking advantage of the ordering of the data frame, skipping
# the first three columns for mean calculation. Afterwards, the data is printed to a file named
# UCI_avg.txt, in the working directory of the code ("UCI HAR Dataset")

avgnames <- c("description",Xnames[usecol])
aveX <- aggregate(trimX[4:length(trimX)],by=list(descripton = trimX$description,
                  activity = trimX$activity,subject = trimX$subject),FUN=mean)

write.table(aveX,file="UCI_avg.txt",sep="\t",row.names=FALSE,col.names=avgnames)

