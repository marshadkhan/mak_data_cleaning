
#working directory set  and importing library
setwd("d:/ds/Cleaning_data/")
library(reshape)

###########################################################1,2#####################################################
# In below steps i have combined 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.

mak_features<-read.csv2("features.txt",header = FALSE, sep = " ")[ ,2]
activity_labels <- read.table("activity_labels.txt",header = FALSE)[,2]

######################################START FOR  TEST DATA SET 
mak_testdata <-read.table("X_test.txt",header = FALSE)
mak_Y_test <-read.table("y_test.txt",header=FALSE)
subject_test <- read.table("subject_test.txt")


mak_traindata <-read.table("X_train.txt",header = FALSE)
mak_traindatalabels <-read.csv2("Y_train.txt",header = FALSE, sep = " ")



#setting column names
colnames(mak_testdata) <-mak_features
#get onely those column names where "Mean","std"
mak_testdata_customized <-mak_testdata[,grep("std|Mean", names(mak_testdata), value=TRUE)]

mak_Y_test[,2] = activity_labels[mak_Y_test[,1]]
names(mak_Y_test) = c("mak_Activity_ID", "mak_Activity_Label")
names(subject_test) = "mak_subject"
mak_final_test_data <- cbind(as.data.table(subject_test), mak_Y_test, mak_testdata_customized)

######################################END FOR TEST DATA SET 

######################################START FOR  TRAIN DATA SET 
mak_traindata <-read.table("X_train.txt",header = FALSE)
mak_Y_train <-read.table("y_train.txt",header=FALSE)
subject_train <- read.table("subject_train.txt")


#setting column names
colnames(mak_traindata) <-mak_features
#get onely those column names where "Mean","std"
mak_traindata_customized <-mak_traindata[,grep("std|Mean", names(mak_traindata), value=TRUE)]

mak_Y_train[,2] = activity_labels[mak_Y_train[,1]]
names(mak_Y_train) = c("mak_Activity_ID", "mak_Activity_Label")
names(subject_train) = "mak_subject"

###bind test data

mak_final_train_data <- cbind(as.data.table(subject_train), mak_Y_train, mak_traindata_customized)

######################################END FOR TRAIN DATA SET 

# Merge test and train data
mak_conoslidated_data = rbind(mak_final_test_data, mak_final_train_data)

#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.

names(mak_conoslidated_data)<-gsub("std()", "SD", names(mak_conoslidated_data))
names(mak_conoslidated_data)<-gsub("mean()", "MEAN", names(mak_conoslidated_data))
names(mak_conoslidated_data)<-gsub("^t", "time", names(mak_conoslidated_data))
names(mak_conoslidated_data)<-gsub("^f", "frequency", names(mak_conoslidated_data))
names(mak_conoslidated_data)<-gsub("Acc", "Accelerometer", names(mak_conoslidated_data))
names(mak_conoslidated_data)<-gsub("Gyro", "Gyroscope", names(mak_conoslidated_data))
names(mak_conoslidated_data)<-gsub("Mag", "Magnitude", names(mak_conoslidated_data))
names(mak_conoslidated_data)<-gsub("BodyBody", "Body", names(mak_conoslidated_data))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(mak_conoslidated_data, "TidyData.txt", row.name=FALSE)

