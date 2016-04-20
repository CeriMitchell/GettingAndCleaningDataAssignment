## Open required libraries
library(reshape2)
        
## Read all activities & names, label aproppriate columns 
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt",
                              col.names=c("activity_id","activity_name"))
        
## Read dataframe's column names
features <- read.table("./data/UCI HAR Dataset/features.txt")
feature_names <-  features[,2]
        
## Read test data & label dataframe columns
testdata <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
colnames(testdata) <- feature_names
        
## Read training data label dataframe columns
traindata <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
colnames(traindata) <- feature_names
        
## Read test subject ids & label dataframe's columns
test_subject_id <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
colnames(test_subject_id) <- "subject_id"
        
## Read test data activity id's & label dataframe's columns
test_activity_id <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
colnames(test_activity_id) <- "activity_id"
        
## Read test subjects ids & label dataframe's columns
train_subject_id <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
colnames(train_subject_id) <- "subject_id"
        
## Read training data activity id's & label dataframe's columns
train_activity_id <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
colnames(train_activity_id) <- "activity_id"
        
##Combine test subject id's, test activity id's & test data into one dataframe
test_data <- cbind(test_subject_id , test_activity_id , testdata)
        
##Combine train subject id's, train activity id's & train data into one dataframe
train_data <- cbind(train_subject_id , train_activity_id , traindata)
        
##Combine test data & train data into one dataframe
all_data <- rbind(train_data,test_data)
        
##Only keep mean() or std() value columns
mean_col_idx <- grep("mean",names(all_data),ignore.case=TRUE)
mean_col_names <- names(all_data)[mean_col_idx]
std_col_idx <- grep("std",names(all_data),ignore.case=TRUE)
std_col_names <- names(all_data)[std_col_idx]
meanstddata <-all_data[,c("subject_id","activity_id",mean_col_names,std_col_names)]
        
##Merge activities dataset with mean/std values dataset, getting one dataset with descriptive activity names
descrnames <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)
        
##Melt dataset with the descriptive activity names for better use
data_melt <- melt(descrnames,id=c("activity_id","activity_name","subject_id"))
        
##Cast melted dataset according to average of each variable for each activity & each subject
mean_data <- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)
        
## Create new tidy dataset file
write.table(mean_data,"./data/UCI HAR Dataset/tidy_movement_data.txt")
        