source('repos/dit/ml/utils/Setup.R');

# Load the dataset & dependencies
DATA = read.csv('repos/dit/datasets/Titanic.csv', stringsAsFactors = FALSE, na.strings = 'NA');

Setup$getPkgs('SDMTools');

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

source('repos/dit/ml/RLab/featured.R');
source('repos/dit/ml/RLab/base_line.R');

Featured = feat_model(DATA);

Asses(Featured$test, Featured$pred);

Baseline = base_model(DATA);

Asses(Baseline$test, Baseline$pred);