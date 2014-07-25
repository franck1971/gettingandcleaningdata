#This routine fundamentally assumes that all the input files are located in the same folder than this routine
#The foolwing Steps purpose is to read all the necessary files for the training data set
datatrain<-read.table("X_train.txt")
datatrainactivity<-read.table("Y_train.txt")
datatrainpeopleid<-read.table("subject_train.txt")
features<-read.table("features.txt")
#these next steps will update the column names of the training data set
updatednames<-features$V2
colnames(datatrain)<-updatednames
#these next steps will update the column names of datatrainactivity and datatrainpeopleid data frames
colnames(datatrainactivity)<-"activity"
colnames(datatrainpeopleid)<-"peopleid"
#this step combines the three different data frames into datatrain data frame
datatrain<-cbind(datatrainpeopleid,datatrainactivity,datatrain)


#The foolwing Steps purpose is to read all the necessary files for the test data set
datatest<-read.table("X_test.txt")
datatestactivity<-read.table("Y_test.txt")
datatestpeopleid<-read.table("subject_test.txt")
features<-read.table("features.txt")
#these next steps will update the column names of the test data set
updatednames<-features$V2
colnames(datatest)<-updatednames
#these next steps will update the column names of datatrainactivity and datatrainpeopleid data frames
colnames(datatestactivity)<-"activity"
colnames(datatestpeopleid)<-"peopleid"
#this step combines the three different data frames into datatrain data frame
datatest<-cbind(datatestpeopleid,datatestactivity,datatest)

#merge the two data frames with the rbind command since same number of columns with same name
datacombined<-rbind(datatrain,datatest)

#Call to the library plyr
library("plyr")

#re-arrange in order the combined data set by the people identification number
datacombined<-arrange(datacombined,peopleid)

#Provide descriptive activity names in the combined data frame

datacombined$activity<-gsub("1","walking",datacombined$activity)
datacombined$activity<-gsub("2","walkingupstairs",datacombined$activity)
datacombined$activity<-gsub("3","walkingdownstairs",datacombined$activity)
datacombined$activity<-gsub("4","sitting",datacombined$activity)
datacombined$activity<-gsub("5","standing",datacombined$activity)
datacombined$activity<-gsub("6","laying",datacombined$activity)


#these next steps will keep only the mean and std data from the combined data frame
myselection<-c("peopleid","activity","mean","std")
datacombinedfinal<-datacombined[,grep(paste(myselection,collapse='|'),colnames(datacombined))]

#combined data set with the average of each variable for each activity and each subject. 

datacombinedfinal<- aggregate(.~ activity + peopleid, data = datacombinedfinal, mean)


#write the final combined data frame to an output text file

write.table(datacombinedfinal,"tidycombineddatafinal.txt",sep=" ")
