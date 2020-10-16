#run_analysis

#1)downloading the raw data dile from the link

dataurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url=dataurl, destfile = "c:/users/hp/documents/project1")
unzip(zipfile = "project1")

#2) Creating dataset containing the train data.
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<- read.table("UCI HAR Dataset/train/subject_train.txt")

#3) Creating dataset containing the test data
x_test<- read.table("UCI HAR Dataset/test/X_test.txt")
y_test<- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test<- read.table("UCI HAR Dataset/test/subject_test.txt")

#4) Merge the train and test datasets.
test<- cbind(subject_test, y_test, x_test)
train<- cbind(subject_train,y_train, x_train)
subject_data<- rbind(subject_train, subject_test)
alldata<- rbind(test,train)


#5) Loading features data
feature<- read.table("UCI HAR Dataset/features.txt")

#6) Loading activity data
activity<- read.table("UCI HAR Dataset/activity_labels.txt")

#7) Giving correct variable names in merged data
featurenames<- as.character(feature$V2)
colnames(alldata)<- c("Subject", "Activity",featurenames) 

#8)Extracting mean and std measurements.
columnstokeep<- grepl("Subject|Activity|mean|std", colnames(alldata))
alldata<- alldata[,columnstokeep]


#9) Using descriptive names for the actvities.
alldata$Activity <- factor(alldata$Activity, levels = activity[,1], labels = activity[,2])
alldata$Subject <- as.factor(alldata$Subject)

#10)Producing the tidy data
meltdata<- melt(alldata, id=c("Subject", "Activity"))
finaldata<- dcast(meltdata,  Subject + Subject ~ variable, mean)

write.table(finaldata,"tidy_data.txt, row.names=FALSE", quote = FALSE)
