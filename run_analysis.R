#This script contains the code used to get and clean the data

library(dplyr)


features <- read.table(paste0(getwd(),"/UCI HAR Dataset/features.txt"))

activity_labels <- read.table(paste0(getwd(),"/UCI HAR Dataset/activity_labels.txt"))

subject_test <- read.table(paste0(getwd(),"/UCI HAR Dataset/test/subject_test.txt"))

subject_train <- read.table(paste0(getwd(),"/UCI HAR Dataset/train/subject_train.txt"))

X_test <- read.table(paste0(getwd(),"/UCI HAR Dataset/test/X_test.txt"))

Y_test <- read.table(paste0(getwd(),"/UCI HAR Dataset/test/Y_test.txt"))

X_train <- read.table(paste0(getwd(),"/UCI HAR Dataset/train/X_train.txt"))

Y_train <- read.table(paste0(getwd(),"/UCI HAR Dataset/train/Y_train.txt"))

set <- rbind(X_test, X_train)

names(set) <- features$V2

set <- set[,grep("mean|std", names(set))]

Y_test$Activity_name <- with(activity_labels, V2[match(Y_test$V1, V1)])

Y_train$Activity_name <- with(activity_labels, V2[match(Y_train$V1, V1)])

activities <- rbind(Y_test, Y_train)

set <- cbind(set, Activity_name = activities[,"Activity_name"])

subjects <- rbind(subject_test, subject_train)

set <- cbind(set, Subjects = subjects[,1])

set_two <- set %>% 
            group_by(Activity_name, Subjects) %>%
            summarize_all(mean) %>%
            data.frame(stringsAsFactors = FALSE)

names(set_two) <-c("Activity_name", "Subject", names(set[1:(ncol(set)-2)]))

write.table(set_two,"set_two.txt",row.names = FALSE)




