library(dplyr)
# First read the train tables into R
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Next, read the test tables into R
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Next, read the features, and activity label
Variables <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# The following five steps are required by the Cousera programming assignment
# in the module "Getting and Cleaning Data" week 4.

# STEP 1: MERGE THE TRAINING AND TEST SETS TO CREATE ONE DATASET
#----------------------------------------------------------------------#

XTotal <- rbind(XTest, XTrain)
YTotal <- rbind(YTest, YTrain)
subTotal <- rbind(subTest, subTrain)


# STEP 2: EXTRACT ONLY THE MEAN AND STD FOR EACH MEASUREMENT
#----------------------------------------------------------------------#

selectMeanStd <- Variables[grep("*mean\\(\\)*|*std\\(\\)*", Variables[ , 2]), ]
subsetX <- XTotal[ , selectMeanStd[ ,1]]

#STEP 3: USE DESPCROPTIVE NAMES TO NAME THE ACTIVITIES IN THE DATASET
#----------------------------------------------------------------------#

colnames(YTotal) <- "NumericalActivityNames"
YTotal$DescriptiveActivityName <- activityLabels[YTotal[ ,1], 2]

#STEP 4: APPROPRIATELY LABEL THE DATASET WITH VARIABLE NAMES
#----------------------------------------------------------------------#

colnames(subsetX) <- selectMeanStd[,2]

# STEP 5: CREATE A SECOND, INDEPENDENT TIDY DATASET WITH THE AVERAGE OF
# EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
#----------------------------------------------------------------------#

colnames(subTotal) <- "Subject"
TidyData <- cbind(subsetX, YTotal$DescriptiveActivityName, subTotal)
SummaryData = summarise_all(group_by(TidyData, YTotal$DescriptiveActivityName, Subject), funs(mean))
write.table(SummaryData, "./UCI HAR Dataset/SummaryData.txt", row.names = FALSE)

