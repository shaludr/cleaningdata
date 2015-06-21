#install package, if you don't have the package install using:
#install.packages("plyr")
#library(plyr)

RunAnalysis <- function(dirPath)
{  
    # add the feature labels using featuredata 
  addFeatureLabel <- function(data, featuresData) 
  {
    #using the getMergeData function add labels
    getMergeData(getMergeData(featuresData, c(562, "SubjectID")), c(563, "ActivityID"))[,2]
  }
  
  addNames <- function(data, activityLabels)
  {
    data <- join(data, activityLabels, by = "ActivityID", match = "first")
    data <- data[,-1]
  }
  
  addDescriptiveVariableNames <- function(data)
  {
    # clean variable names
    names(data) <- gsub('\\(|\\)',"",names(data), perl = TRUE)
    names(data) <- make.names(names(data))
    
    # modify variable names to be more descriptive to the reader
    names(data) <- gsub('^t',"Time-",names(data))
    names(data) <- gsub('^f',"Frequency-",names(data))
    names(data) <- gsub('Freq\\.',"Freq-",names(data))
    names(data) <- gsub('Freq$',"Freq",names(data))
    
    data
  }
  
  ## exposed functions  
  # getMerge - helps merge two datasets into one and returns the merged data
  getMergeData <- function(dataset1, dataset2)
  {
    mergedData <- rbind(dataset1, dataset2)    
  }
  
  # calls other functions above and writes out a tidy data text file in working directory
  writeTidyData <-  function(fileName)
  {
    # intialize datasets        
    xTest <- read.table(file.path(dirPath, "test/X_test.txt"))
    yTest <- read.table(file.path(dirPath, "test/Y_test.txt"))
    xTrain <- read.table(file.path(dirPath, "train/X_train.txt"))
    yTrain <- read.table(file.path(dirPath, "train/Y_train.txt"))
    subjectTest <- read.table(file.path(dirPath, "test/subject_test.txt"), header=F, col.names=c("SubjectID"))
    subjectTrain <- read.table(file.path(dirPath, "train/subject_train.txt"), header=F, col.names=c("SubjectID"))
    activityLabels <- read.table(file.path(dirPath, "activity_labels.txt"), 
                                     col.names = c("ActivityID", "ActivityName"))    
    featuresData <- read.table(file.path(dirPath, "features.txt"), colClasses = c("character")) 
    
    # Merges the training and the test sets to create one data set.
    train <- cbind(cbind(xTrain, subjectTrain), yTrain)
    test<- cbind(cbind(xTest, subjectTest), yTest)
    completeMerge <- getMergeData(train, test)
    
    # add feature labels 
    names(completeMerge) <- addFeatureLabel(completeMerge, featuresData)
    
    # extracts only the measurements on the mean and standard deviation for each measurement. 
    extracedData <- completeMerge[,grepl("mean|std|SubjectID|ActivityID", names(completeMerge))]
    
    # add descriptive activity names to name the activities in the data set
    extracedData = addNames(extracedData, activityLabels)
    
    # appropriately labels the data set with descriptive variable names
    extracedData = addDescriptiveVariableNames(extracedData)
    
    # creates a second, independent tidy data set with the average of each variable for each activity and each subject
    secondTidyData = ddply(extracedData, c("SubjectID","ActivityName"), numcolwise(mean))
    write.table(secondTidyData, file = fileName)
  }
  
  list(getMergeData = getMergeData,writeTidyData = writeTidyData)
}
