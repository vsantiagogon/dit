ROOT = 'repos/dit/ml/'

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('C50', 'dataQualityR', 'dplyr'));

DATA = read.csv(paste(ROOT, '../datasets/UCI_Credit_Card.csv', sep = ''), stringsAsFactors = F);

Asses = function (test, pred) {
  # Finally, we show the results, using the confusion matrix.
  mat = confusion.matrix(test, pred)
  TN = mat[1, 1]
  TP = mat[2, 2]
  FN = mat[1, 2]
  FP = mat[2, 1]
  TOTAL = TP + TN + FN + FP;
  
  Accuracy = (TP + TN)/TOTAL
  Precision = TP / (TP + FP); 
  MisRate  = (FP + FN) / TOTAL
  
  cat('ACCURACY: ', Accuracy, ' PRECISION: ', Precision, ' Mis. Rate: ', MisRate)
  
}

data = Setup$split(DATA, 'ID'); 

train_labels = data$train$default.payment.next.month %>% as.factor;
train = subset(data$train, select = -c(ID, default.payment.next.month));
test  = subset(data$test,  select = -c(ID, default.payment.next.month));
test_labels = data$test$default.payment.next.month %>% as.factor;

model <- C5.0(train, train_labels);

pred <- predict(model, test_labels);

Asses(test_labels, pred);