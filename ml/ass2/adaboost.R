ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));
source(paste(ROOT, 'common/Algo.R', sep = ''));

Utils$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr', 'SDMTools'));

DATA = read.csv(paste(ROOT, 'dataset/spam.csv', sep = ''));
DATA = DATA[sample(nrow(DATA)), ];

SETS = Utils$split(DATA);


labels = names(SETS$train) %>% setdiff('spam');

adaboost = function (train, test, M, clf) {
  n = nrow(train);
  
  w = rep(1/n, n);

  train$spam = ifelse(train$spam == 0, -1, 1);
  test$spam  = ifelse(test$spam  == 0, -1, 1);
  
  output = rep(0, nrow(test)); # General model is a sum. We use neutral 0 to initialize
  
  for (i in 1:M) {
    model      = clf(spam ~ ., data = train, weights = w);
    # We want to modify weights on those points where we find difficulties to predict. 
    # That's why we do this silly thing of calculate predictions over the train dataset.
    preds      = ifelse(predict(model, train[, labels]) < 0, -1, 1 );
    preds_test = ifelse(predict(model, test[, labels]) < 0, -1, 1 );
    
    ind = data.frame(actual = train$spam, preds = preds) %>% mutate(ind = ifelse(actual != preds, 1, 0)) %>% select(ind);
    
    err = sum(w %*% ind[ , 1 ]) / sum(w);
    
    alpha = 0.5 * log( (1 - err )/ err );
    
    w = w * exp(alpha * ind[, 1]);
  
    output = output + c(alpha * preds_test);
  }
  
  return ( sign(output) );
}

x = adaboost(SETS$train, SETS$test, 100, rpart);

Utils$asses(SETS$test$spam , x);

print('--------------------------------');

m = rpart(spam ~ ., data = SETS$train);
p = ifelse( predict(m, SETS$test[ , labels]) > 0.5, 1, 0);
Utils$asses(SETS$test$spam, p);
