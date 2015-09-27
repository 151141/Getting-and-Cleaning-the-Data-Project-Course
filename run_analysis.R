library(reshape) #load the package "reshape" which defines the function "melt" used below
library(reshape2) #load the package "reshape2" which defines the function "dcast" used below
library(plyr) #load the package "plyr"

setwd("D:/My Documents/Coursera Data Science/getting and cleaning the data/ProjectCourseDataset/newData") # set the working directory, where all the relevant files have been collected

subject_test <- read.table("subject_test.txt") # in rows 3 to 10 the data is read 
subject_train <- read.table("subject_train.txt") 

X_test <- read.table("X_test.txt") 
y_test <- read.table("y_test.txt")

X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")

testSet <- cbind(subject_test, y_test, X_test) #put all the "_test" data together, by binding the columns corresponding to the "subject ID", "activity label" and "observations/measurements", respectively
trainSet <- cbind(subject_train, y_train, X_train) #put all the "_train" data together, by binding the columns corresponding to the "subject ID", "activity label" and "observations/measurements", respectively

totalSet  <- rbind(testSet, trainSet) #construct the total set formed by binding all the rows in the two previously constructed datasets, i.e. "testSet" and "trainSet"

colnames(totalSet)[1] <- "SubjectID" #rename the first column in totalSet to "SubjectID"
colnames(totalSet)[2] <- "ActivityLabel" # rename the second column in totalSet to "ActivityLabel"

totalSet$ActivityLabel <- factor(totalSet$ActivityLabel) #convert the "ActivityLabel" column from 'numeric' to 'factor', with the purpose of renaming the activity labels (i.e. 1, 2, 3, etc) to their corresponing name (i.e. "Walking", "Walking Upstairs" etc) 
levels(totalSet$ActivityLabel) <- c("Walking", "Walking_upstairs", "Walking_downstairs", "Sitting", "Standing", "Laying") #renaming factor labels


#based on the information in the file "features.txt", we select below only the measurements corresponding to mean() and standard deviation()
#variables corresponding to mean(): "V1", "V2", "V3", "V41", "V42", "V43", "V81", "V82", "V83", "V121", "V122", "V123", "V161", "V162", "V163", "V201", "V214", "V227", "V240", "V253", "V266", "V267", "V268", "V345", "V346", "V347", "V424", "V425", "V426", "V503", "V516", "V529", "V542"
#variables corresponding to std(): "V4", "V5", "V6", "V44", "V45", "V46", "V84", "V85", "V86", "V124", "V125", "V126", "V164", "V165", "V166", "V202", "V215", "V228", "V241", "V254", "V269", "V270", "V271", "V348", "V349", "V350", "V427", "V428", "V429", "V504", "V530", "V543"

MeanStd <- subset(totalSet, select = c("SubjectID", "ActivityLabel", "V1", "V2", "V3", "V41", "V42", "V43", "V81", "V82", "V83", "V121", "V122", "V123", "V161", "V162", "V163", "V201", "V214", "V227", "V240", "V253", "V266", "V267", "V268", "V345", "V346", "V347", "V424", "V425", "V426", "V503", "V516", "V529", "V542", "V4", "V5", "V6", "V44", "V45", "V46", "V84", "V85", "V86", "V124", "V125", "V126", "V164", "V165", "V166", "V202", "V215", "V228", "V241", "V254", "V269", "V270", "V271", "V348", "V349", "V350", "V427", "V428", "V429", "V504", "V530", "V543"))

#starting from "MeanStd", we construct a tidy dataset by melting the columns in the initial set. This creates a set where each row corresponds to a unique observation for each "SubjectID" and "ActivityLabel"
tidyDataset <- melt(MeanStd, id = c("SubjectID", "ActivityLabel"))

#cast the molten data frame "tidyDataset" to produce the average per SubjectID, ActivityLabel and Variable, respectively
#as a verification, note the resulting data has 180 rows, corresponing to 30 subjects multiplied by 6 activities

avg_group_by <- dcast(tidyDataset, SubjectID + ActivityLabel ~ variable, mean) 

head(avg_group_by, n = 8)
