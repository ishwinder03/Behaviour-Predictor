# Load necessary libraries  
library(readxl)  
library(randomForest)  
# install.packages("tidyverse")
# install.packages("tidymodels")
# install.packages("writexl")  
library(writexl)  
source('build classifier.R')

library(tidymodels)
library(tidyverse)
# Read the new dataset - of just the classifiers 
bp_data <- read_excel("C:/Users/isandhu004/OneDrive - PwC/Documents/BP Data/bp_data.xlsx")  
new_data <- bp_data


#Selecting just the classifiers 
new_X <- new_data[, 1:12]  

#new_X_outspoken_incl <- new_data[, 1:13]  # For model rf_out_with_outspoken  

# Make predictions using the trained models  
predictions <- predict(rf_out, new_X)  

# Adding new column to the classifiers data set and overall data set - only works 
# provided that the rows have not moved around
new_data$predictions <- predictions 
#CH_CLASS$predictions <- predictions
# CH$predictions <- predictions
#predictions_with_outspoken <- predict(rf_out_with_outspoken, new_X_outspoken_incl)  

# Inspect the predictions  
print(predictions) 
summary(predictions)

# Number of each type in each data set 
table(rf_test[,14]) 
#1 = SA, 2 = BS, 3 = AL, 4 = PJ, 5 = SS <- Personality type with number in prediction - I guess? Need the key
# ^ This is clear (maybe) by slide 7 in 3-3-22 Internal Psychographcics data 
# Define the path to your Documents folder  
documents_path <- "C:/Users/isandhu004/OneDrive - PwC/Documents/BP Data"    

# Create the full file path for the Excel file  
file_path <- file.path(documents_path, "bp_data1.xlsx")  

# Export the data frame to an Excel file  
write_xlsx(bp_data1, file_path)  


#print(predictions_with_outspoken)  

###################### Okay this works now 
# Get column names of the training data  
training_columns <- colnames(rf_test[,1:12]) # or rf_test[,1:13] depending on the model  

# Get column names of the new data  
new_data_columns <- colnames(bp_data1)  

# Print column names for comparison  
print(training_columns)  
print(new_data_columns)  
# Need the columns to be identical

