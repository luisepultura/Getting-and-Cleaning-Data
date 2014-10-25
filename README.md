##createOutputFile function  


### Description  

The createOutputFile function creates a data set with the avarage of each variable for each activity and each     subject as required by the project assigment for Getting and Cleaning Data.  

###Arguments  

The name of the files in which the data are to be read from. _The files names are relative to local working directory_.

### Details  

The function first loads the libraries plyr, dplyr and sqldf to be used in the analysis, then the required test and training data sets are read into memory.

On STEP 1 three new sets(_X_,_y_ and _subject_) get created by combining training and test data, the order in which the arguments are passed to the bind function is important.

on STEP 2 a new version of the features vector preveiously read is filtered based on mean and standard deviation, this new vector contains the indexes in which the _X_ varibales match the mean and standard deviation measures, _X_ is reset.

on STEP the _from_ and _to_ vectors are created which correspond to the acivity labels value and description, these are used to transform the activity values into descriptive names.

on STEP 4 the _X_,_y_ and _subject_ variables are named appropriately, and a new _yX_ set is created, this final set consists of the training and test sets along with the subject and activities accordingly labeled.

STEP 5 the desired data set is created.

