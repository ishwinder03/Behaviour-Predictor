# Checking 

# First combine new_data and rf_test

# Install and load dplyr package  
install.packages("dplyr")  
library(dplyr)  

# Assuming new_data and rf_test are your data frames  
# For example:  
# new_data <- data.frame(A = c(1, 2, 3), B = c(4, 5, 6))  
# rf_test <- data.frame(A = c(1, 2, 7), B = c(4, 5, 8))  
new_data1 <- new_data 
names(new_data1)[names(new_data1) == 'predictions'] <- 'segment'
# remove duplicates from both first then combine 
new_data1 <- unique(new_data1) 
rf_test1 <- unique(rf_test) 



# Concatenate the two data frames  

# Assuming df and rf_test are your data frames  
merged_data <- rbind(new_data1, rf_test1)  

# View the merged data frame  
#print(merged_df)  


# Check for identical rows  
duplicate_rows <- merged_data[duplicated(merged_data) | duplicated(merged_data, fromLast = TRUE), ]  

print("Merged Data:")  
print(merged_data)  
print("\nDuplicate Rows:")  
print(duplicate_rows)  

duplicate_rows # these are entry rows that we can use to check if the segment we get in our predictor sheet is the same 
# as the segment the model was trained on - obviously these wont always be correct because it is a model but gives a good indication
# if our analysis so far is correct. # cOULD SET UP A DOUBLE FOR LOOP FOR THIS TO CHECK EVERY ROW AGAINST EACHOUTHER 

# Then check for duplicates 


# Cleaning the dtata 
# Remove \r\r\n from column names  
cleaned_colnames <- gsub("\r\r\n", "", colnames(CH_data))  

# Assign the cleaned column names back to the data frame  
colnames(CH_data) <- cleaned_colnames  

# Verify the column names are cleaned  
print(colnames(CH_data)) 
