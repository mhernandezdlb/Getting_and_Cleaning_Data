# CodeBook
The run_analysis.R script performs the requested activities in project assignment.The script executes the following steps

# Downloading the dataset
Downloads and extracts the content of the "getdata_projectfiles_UCI HAR Dataset.zip" in the directory. It previously veryfies if the dataset is already availble. If not, it will extract the folder "UCI HAR Dataset"

# Reading the data
The script reads the datasets and store them in variables using read.table():
- features <- 'features.txt' : 561 rows, 2 columns
-- List of all features with condensed labels.
- activities <- 'activity_labels.txt' : 6 rows, 2 columns
- Links the class labels with their activity name.
- Labels: LAYING, SITTING, STANDING, WALKING,WALKING_DOWNSTAIRS, WALKING_UPSTAIRS 
- x_test <- 'test/X_test.txt' : 2947 rows, 561 columns
                - Test data set. Features added as columnames using "col.names" argument
        - subject_test <- 'test/subject_test.txt' : 2947 rows, 1 column
                - List of 9 test subjects linked to the 'x_test.txt' file
        - y_test <- 'test/y_test.txt' : 2947 rows, 1 columns
                - List of activity codes linked to "x_test" data set.
        - x_train <- 'test/X_train.txt' : 7352 rows, 561 columns
                - Training data set. Features added as columnames using "col.names" argument
        - subject_train <- 'test/subject_train.txt' : 7352 rows, 1 column
                - List of 21 subjects linked to the 'x_train.txt' file
        - y_train <- test/y_train.txt : 7352 rows, 1 columns
                - List of activity codes linked to "x_train" data set.
# Merging the data
The script merges "x", "y" and "subject" for training and test datasets using "mutate()" from dplyr library:
        - test (2947 obs, 563 variables)
        - train (7352 obs, 563 variables)
It merges training and test datasets using rbind()
        - merged_data (10299 obs, 563 variables)
# Extracting mean and standard deviation variables
Creates a subset selecting mean and standard deviation for each measurement, using "select()" and "contains()" as argument. As mean is also part of other measurements, "mean..." and "std.." were used as arguments for "contains()"
        - selected_data (10299 obs, 50 variables)
# Using descriptive activity names to name the activities in the data set
The script uses "activities" to change the activity code for and activity description 

# Labelling the data set with descriptive variable names
Replacements were made using "gsub()" with the following considerations
        - "t" and "f" represent time and frequency domains
        - All "t" replaced by "Time"
        - All "f" replaced by "Frequency"
        - "Acc" means accelerometer's data. Nevertheless, the actual measurement is linear acceleration
        - All "Acc" replaced by "Acceleration" 
        - "Gyro" means gyroscopes's data. Nevertheless, the actual measurement is angular velocity
        - All "Gyro" replaced by "Velocity"
# Averaging variables by subject and activity
Creates a summarized dataframe using "group_by()" with "subject" and "activity" as arguments and "summarize_all()" with mean as a function
        - summarized_data (180 obs, 50 variables)
# Generating tidy dataset
Creates the requested dataset using "write.table()"
        - "tidy_dataset.txt"
