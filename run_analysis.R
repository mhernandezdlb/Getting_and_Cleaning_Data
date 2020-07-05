library(dplyr)
## DOWNLOADING THE DATABASE
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
myURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(filename)){
        fileURL <- myURL
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}
## READING ALL THE DATA PIECES
features <- read.table("UCI HAR Dataset/features.txt",
                       col.names = c("n" ,"feature"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt",
                         col.names = c("ID", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
                       col.names = features$feature)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                       col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                      col.names = features$feature)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      col.names = "code")
## ANALIZING THE DATA
## 1. Merges the training and test datasets, subjects and activity codes
test<- mutate(x_test, code = y_test$code, subject = subject_test$subject)
train <- mutate(x_train, code= y_train$code, subject = subject_train$subject)
merged_data <- rbind(train, test)
## 2. Extracts mean and standard deviation for each meassurement
selected_data <- merged_data %>% 
        select(subject, code, contains("mean..."), contains("std...")) %>%
        rename("activity"=code)
## 3. Use descriptive activity names
selected_data$activity <- activities[selected_data$activity,"activity"]
## 4. Label the dataset
names(selected_data)<- gsub("tBodyAcc", "BodyAccelarationTime", names(selected_data))
names(selected_data)<- gsub("tGravityAcc", "GravityAccelerationTime", names(selected_data))
names(selected_data)<- gsub("tGravityGyro", "GravityVelocityTime", names(selected_data))
names(selected_data)<- gsub("tBodyGyro", "BodyVelocityTime", names(selected_data))
names(selected_data)<- gsub("fBodyAcc", "BodyAccelarationFrequency", names(selected_data))
names(selected_data)<- gsub("fBodyGyro", "BodyVelocityFrequency", names(selected_data))
names(selected_data)<- gsub("mean...", "Mean-", names(selected_data))
names(selected_data)<- gsub("std...", "STD-", names(selected_data))
## 5. Average of each variable per activity and  subject
summarized_data <- selected_data %>%
        group_by(subject, activity) %>%
        summarise_all(mean)
## 6. Generates tidy data set with write.table()
write.table(summarized_data, "tidy_data.txt", row.names = FALSE)