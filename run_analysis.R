## 1.Merges the training and the test sets to create one data set

train_XTrain_table <- read.table("train/X_train.txt", header = FALSE)
test_X_table <- read.table("test/X_test.txt", header = FALSE)
XTrainBind <- rbind(train_XTrain_table, test_X_table)

train_Subject_table <- read.table("train/subject_train.txt", header = FALSE)
test_Subject_table <- read.table("test/subject_test.txt", header = FALSE)
SubjectBind <- rbind(train_Subject_table, test_Subject_table)

train_YTrain_table <- read.table("train/y_train.txt", header = FALSE)
test_Y_table <- read.table("test/y_test.txt", header = FALSE)
YBind <- rbind(train_YTrain_table, test_Y_table)

## 2.Extracts only the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt", header = FALSE)

idx_features <- grep("-mean\\(\\)|-std\\(\\)", features$V2) 
XTrainBind <- XTrainBind[, idx_features] 
names(XTrainBind) <- gsub("\\(|\\)", "", (features[idx_features, 2]))

## 3.Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt", header = FALSE)

## 4.Appropriately labels the data set with descriptive variable names
YBind[, 1] = activity_labels[YBind[, 1], 2]
names(YBind) <- "activity"
names(SubjectBind) <- "subject"

bindDataSets <- cbind(XTrainBind, YBind, SubjectBind)

## 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject
result <- aggregate(bindDataSets,list(bindDataSets$subject, bindDataSets$activity), mean)

names(result)[1] <- "subject"
names(result)[2] <- "activity"

write.table(result, "tidy_average_dataset.txt", row.name=FALSE)
