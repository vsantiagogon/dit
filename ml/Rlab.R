if (!require('dataQualityR')) {
  install.packages('dataQualityR');
}
library(dataQualityR);

train = read.csv('repos/dit/ml/train.csv', stringsAsFactors = FALSE)

num.file <- paste(tempdir(), "/dq_num.csv", sep= "")
cat.file <- paste(tempdir(), "/dq_cat.csv", sep= "")
checkDataQuality(data= train, out.file.num= num.file, out.file.cat= cat.file)