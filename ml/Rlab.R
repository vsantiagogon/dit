# Non-annoying package loading
packages = function (pkgs) {
  for (pkg in pkgs) {
    if (!(pkg %in% installed.packages())) install.packages(pkg);
    library(pkg, character.only = T);
  } 
}
packages(c('dataQualityR','class', 'dplyr', 'ggplot2', 'SDMTools'))

# Load the dataset
data = read.csv('repos/dit/ml/train.csv', stringsAsFactors = FALSE, na.strings = 'NA')

# NORMALIZE
normalize <- function(x) { 
  return ((x - min(x)) / (max(x) - min(x))) 
}

# GET DATA QUALITY REPORT. 
getDataQuality <- function (df) {
  num.file <- paste(tempdir(), "/dq_num.csv", sep= "")
  cat.file <- paste(tempdir(), "/dq_cat.csv", sep= "")
  checkDataQuality(data= df, out.file.num= num.file, out.file.cat= cat.file)
  
  DQ.numerical = read.csv(paste(tempdir(), '/dq_num.csv', sep= ''))
  DQ.categorical = read.csv(paste(tempdir(), '/dq_cat.csv', sep= ''))
  
  # Don't pollute the local system
  file.remove(paste(tempdir(), '/dq_num.csv', sep= ''))
  file.remove(paste(tempdir(), '/dq_cat.csv', sep= ''))
  
  return (list(
    'Numerical' = DQ.numerical,
    'Categorical' = DQ.categorical
  ))
}
 
###################### MAIN #####################################

### REPORT INITIAL DATA QUALITY

DQ = getDataQuality(data);
#View(DQ$Numerical);
#View(DQ$Categorical);

### DATA PREPARATION

# Obvious drops
data = subset(data, select = -c(Name, Ticket))

# Cabin has a ~77% of missing values. We drop it as well.

data = subset(data, select = -c(Cabin))

# Only 0.22% of missing values in Embarked column. We'll drop the rows with NA's.

data = filter(data, Embarked != '');

# Age contains a 22% of NA's. We impute them using the median.
data[is.na(data$Age) == TRUE, ]$Age = mean(data$Age, na.rm = TRUE)

# Check data quality again.
DQ = getDataQuality(data);
#View(DQ$Numerical)
#View(DQ$Categorical)

### DATA VISUALIZATION. 

## Continuous variables. 

#ggplot(data, aes(x = Age, y = Fare)) + geom_point() + theme_classic() + ggtitle('Fare vs Age')

### KNN

train = head(data, round(0.7 * nrow(data)));
test  = tail(data, nrow(data) - round(0.7 * nrow(data)));

# Randomize the data
data <- data[sample(1:nrow(data)), ]

# KNN implementation can only deal with numeric values
train$Sex = sapply(as.character(train$Sex), switch, 'male' = 0, 'female' = 1);
train$Embarked = sapply(as.character(train$Embarked), switch, 'C' = 0, 'Q' = 1, 'S' = 2);

test$Sex = sapply(as.character(test$Sex), switch, 'male' = 0, 'female' = 1);
test$Embarked = sapply(as.character(test$Embarked), switch, 'C' = 0, 'Q' = 1, 'S' = 2);

# OK, ready to run
predictions <- data.frame(
  'ID' = test$PassengerId,
  'Survived' = knn(select(train, -c(PassengerId, Survived)), select(test, -c(PassengerId, Survived)), train$Survived, k=10, l=0)
) %>% arrange(ID)

# Finally, we show the results
View(predictions)
View(test)

# And calculate the confusion matrix.
mat = confusion.matrix(test$Survived, predictions$Survived)
TN = mat[1, 1]
TP = mat[2, 2]
FN = mat[1, 2]
FP = mat[2, 1]
TOTAL = TP + TN + FN + FP;

Accuracy = (TP + TN)/TOTAL
Precision = TP / (TP + FP); 
MisRate  = (FP + FN) / TOTAL
cat('ACCURACY: ', Accuracy, ' PRECISION: ', Precision, ' Mis. Rate: ', MisRate)