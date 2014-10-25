    createOutputFile<-function(){
        ##LIBRARIES TO BE USED IN ANALYSIS
        loadLibraries()
        
        ##FILES LOCATION
        trainXLoc<-"./train/X_train.txt"
        testXLoc<-"./test/X_test.txt"
        trainyLoc<-"./train/y_train.txt"
        testyLoc<-"./test/y_test.txt"
        featuresLoc<-"features.txt"
        trainSubjectLoc<-"./train/subject_train.txt"
        testSubjectLoc<-"./test/subject_test.txt"
        
        ##LOAD DATA REQUIRE FOR ANALYSIS
        ##X train & test data sets
        trainX<-loadDataFrom(trainXLoc)
        testX<-loadDataFrom(testXLoc)
        
        ##y train & test data sets
        trainy<-loadDataFrom(trainyLoc)
        testy<-loadDataFrom(testyLoc)
        
        ##subject data
        trainSubject<-loadDataFrom(trainSubjectLoc)
        testSubject<-loadDataFrom(testSubjectLoc)
        
        ##features vector
        features<-loadDataFrom(featuresLoc)
        
        ##STEP 1. row bind X, y & subject data sets
        ##X, y & subject data sets will be column binded at a later step
        X<-rbind(trainX,testX)
        y<-rbind(trainy,testy)
        subject<-rbind(trainSubject,testSubject)
        
        ##STEP 2
        ##filter features vector on mean and standard deviation measures
        filteredFeatures<-sqldf("select * from features where V2 like '%mean()%' or V2 like '%std%'")
        
        ##V1 column in filteredFeatures frame contains 
        ##index to select only the measurements on the mean and standard deviation for X
        X<-X%>%select(filteredFeatures$V1)
        
        ##STEP 3
        ##Activity labels vector
        from<-c(1,2,3,4,5,6)
        to<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
              "SITTING","STANDING","LAYING")
        
        ##transform y values to activity labels
        y$V1<-mapvalues(y$V1,from,to)
        
        ##STEP 4
        ##label X with descriptive variable names based on filteredFeatures vector
        colnames(X)<-filteredFeatures$V2
        colnames(y)<-"Activity"
        colnames(subject)<-"subject"
        
        ##final data set
        yX<-cbind(subject,y,X)
        
        ##STEP 5
        output<-yX%>%group_by(Activity,subject)%>%summarise_each(funs(mean))
        write.table(output, file="OUTPUT.txt",row.name=FALSE)
    }   
    
    loadLibraries<-function(){
        library(plyr)
        library(dplyr)
        library(sqldf)
    }
    
    loadDataFrom<-function(fileLocation){
        read.table(fileLocation)
    }
    
