# install.packages("randomForest")
# install.packages("readxl")  

library(randomForest)
library(readxl)

# file_path <- "c:/Users/isandhu004/OneDrive - PwC/Documents/BP Data/rf_test.xlsx"  
# file.exists(file_path)  

rf_test <- as.data.frame(read_excel("rf_test.xlsx"))
View(rf_test)

X <- rf_test[,1:12]
X_outspoken_incl <- rf_test[,1:13]
y <- as.factor(rf_test[,14])

rf_out_with_outspoken <- randomForest(y = y, x = X_outspoken_incl, ntree = 1000)
rf_out <- randomForest(y = y, x = X, ntree = 1000)

print(rf_out)
print(rf_out_with_outspoken)

varImpPlot(rf_out)
varImpPlot(rf_out_with_outspoken)

# For tuning: https://www.hackerearth.com/practice/machine-learning/machine-learning-algorithms/tutorial-random-forest-parameter-tuning-r/tutorial/
