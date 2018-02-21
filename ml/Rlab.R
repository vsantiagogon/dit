packages = function (pkgs) {
  for (pkg in pkgs) {
    if (!(pkg %in% installed.packages())) install.packages(pkg);
    library(pkg, character.only = T);
  } 
}

packages(c('dataQualityR','class', 'dplyr', 'ggplot2')) #gmodels


data = read.csv('repos/dit/ml/train.csv', stringsAsFactors = FALSE, na.strings = 'NA')

# DATA QUALITY REPORT. 
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
View(DQ$Numerical);
View(DQ$Categorical);

### DATA PREPARATION

# Obvious drops
data = subset(data, select = -c(Name, Ticket))

# Cabin has a ~77% of missing values. We drop it as well.

data = subset(data, select = -c(Cabin))

# Only 0.22% of missing values in Embarked column. We'll drop the rows with NA's.

data = filter(data, Embarked != '');

# Age contains a 22% of NA's. We impute them using the median.
data[is.na(data$Age) == TRUE, ]$Age = median(data$Age, na.rm = TRUE)

# Check data quality again.
DQ = getDataQuality(data);
View(DQ$Numerical)
View(DQ$Categorical)

### DATA VISUALIZATION. 

## Continuous variables. 

ggplot(data, aes(x = Age, y = Fare)) + geom_point() + theme_classic() + ggtitle('Fare vs Age')

### KNN

# The algorithm can only deal with numbers.

data$Sex = sapply(as.character(data$Sex), switch, 'male' = 0, 'female' = 1);
data$Embarked = sapply(as.character(data$Embarked), switch, 'C' = 0, 'Q' = 1, 'S' = 2);

# Randomize the data
data = data[sample(nrow(data)), ]

train = head(data, round(0.7 * nrow(data)));
test  = tail(data, nrow(data) - round(0.7 * nrow(data)));

predictions <- data.frame(
  'ID' = test$PassengerId,
  'Survived' = knn(select(train, -c(PassengerId)), select(test, -c(PassengerId)), train$Survived, k=10)
) %>% arrange(ID)

View(predictions)