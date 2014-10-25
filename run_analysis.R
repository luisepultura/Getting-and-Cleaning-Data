    createOutputFile<-function(trainXfile,testXfile,trainyfile,testyfile,
                               trainsubject,testsubject,featuresfile){
        
        ##LIBRARIES TO BE USED IN ANALYSIS
        library(plyr)
        library(dplyr)
        library(sqldf)
        
        ##LOAD REQUIRED DATA FOR ANALYSIS
        trainX<-read.table(trainXfile)
        testX<-read.table(testXfile)
        trainy<-read.table(trainyfile)
        testy<-read.table(testyfile)
        trainSubject<-read.table(trainsubject)
        testSubject<-read.table(testsubject)
        features<-read.table(featuresfile)
        
        ##STEP 1
        X<-rbind(trainX,testX)
        y<-rbind(trainy,testy)
        subject<-rbind(trainSubject,testSubject)
        
        ##STEP 2
        filteredFeatures<-sqldf("select * from features where V2 like '%mean()%' or V2 like '%std%'")
        
        X<-X%>%select(filteredFeatures$V1)
        
        ##STEP 3
        from<-c(1:6)
        to<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
              "SITTING","STANDING","LAYING")
        
        y$V1<-mapvalues(y$V1,from,to)
        
        ##STEP 4
        colnames(X)<-filteredFeatures$V2
        colnames(y)<-"Activity"
        colnames(subject)<-"subject"
        
        yX<-cbind(subject,y,X)
        
        ##STEP 5
        output<-yX%>%group_by(Activity,subject)%>%summarise_each(funs(mean))
        write.table(output, file="OUTPUT.txt",row.name=FALSE)
    }  
    
    ##FILES
    trainXfile<-"./train/X_train.txt"
    testXfile<-"./test/X_test.txt"
    trainyfile<-"./train/y_train.txt"
    testyfile<-"./test/y_test.txt"    
    trainsubject<-"./train/subject_train.txt"
    testsubject<-"./test/subject_test.txt"
    featuresfile<-"features.txt"  
    
    createOutputFile(trainXfile,testXfile,trainyfile,testyfile,
                     trainsubject,testsubject,featuresfile)
