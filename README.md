gcd-project
===========

This is the project for Coursera's Getting and Cleaning Data class. The R script in this repository named run_analysis.R is used to read and process motion sensor data from Samsung Galaxy S II smartphones, collected by the University of California, Irvine Machine Learning Institute. The data is used to classify human activity:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data can be obtained from the following file:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The working directory in R should be set to the directory that gets created upon unzipping the above file, named "UCI HAR Dataset". The run_analysis.R script is then run, creating a file containing the average mean and standard deviation readings from the sensor data, for each combination of activity and subject.

