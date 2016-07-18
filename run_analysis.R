## Getting and Cleaning Data - Course Project
##
## load data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "Activity"))
features <- read.table("UCI HAR Dataset/features.txt", colClasses = "character")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## merges the training and the test sets to create one data set
train_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)
all_data <- rbind(train_data, test_data)
names(all_data) <- c("Subject", "ActivityID", features[,2])

## extracts only the measurements on the mean and standard deviation for each measuremen 
extract_data <- all_data[, grepl("Subject|ActivityID|mean|std", names(all_data))]

## uses descriptive activity names to name the activities in the data set
join_data <- left_join(extract_data, activity_labels, by = "ActivityID")

## appropriately labels the data set with descriptive variable names
names(join_data) <- gsub("Acc", "Acceleration", names(join_data))
names(join_data) <- gsub("Gyro", "AngularVelocity", names(join_data))
names(join_data) <- gsub("\\(\\)", "", names(join_data))

## creates tidy data set with the average of each variable for each activity and each subject
melt_data <- melt(join_data, id = c("Subject", "Activity"), measure.vars = c(names(join_data[3:81])))
melt_data_mean <- dcast(melt_data, Subject + Activity ~ variable, mean)
write.table(melt_data_mean, file = "tidy_data.txt")
