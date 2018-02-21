if (!require('dataQualityR')) {
  install.packages('dataQualityR');
}
library(dataQualityR);

if (!require('class')) {
  install.packages('class');
}
library(class);

if (!require('gmodels')) {
  install.packages('gmodels')
}
library(gmodels)

if (!require('dplyr')) {
  install.packages('dplyr')
}
library(dplyr)

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
    'Continuous' = DQ.numerical,
    'Categorical' = DQ.categorical
  ))
}
 
###################### MAIN #####################################

### REPORT INITIAL DATA QUALITY

DQ = getDataQuality(data);
View(DQ$Continuous);
View(DQ$Categorical);

### DATA PREPARATION

# Obvious drops
data = subset(data, select = -c(PassengerId, Name, Ticket))

# Cabin has a ~77% of missing values. We drop it as well.

data = subset(data, select = -c(Cabin))

# Only 0.22% of missing values in Embarked column. We'll drop the rows with NA's.

data = filter(data, Embarked != '');

# Age contains a 22% of NA's. We impute them using the median.
data[is.na(data$Age) == TRUE, ]$Age = median(data$Age, na.rm = TRUE)

# Check data quality again.
DQ = getDataQuality(data);

View(DQ$Continuous)
View(DQ$Categorical)