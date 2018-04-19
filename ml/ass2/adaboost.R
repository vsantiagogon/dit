ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));
source(paste(ROOT, 'common/Algo.R', sep = ''));

Utils$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr', 'SDMTools'));

DATA = read.csv(paste(ROOT, 'dataset/spam.csv', sep = ''));
DATA = DATA[sample(nrow(DATA)), ];

SETS = Utils$split(DATA);

tree = function (train, weights = c(), ada = FALSE) {
  labels = setdiff(names(train), 'spam');
  if (ada) {
    fit = rpart(spam ~ ., data = train, weights = weights)
  } else {
    fit = rpart(spam ~ ., data = train);    
  }

  return (function (test) {
    if (ada) {
      return(ifelse( predict(fit, test[ ,labels]) > 0.5, 1, -1 ))  
    } else {
      return(ifelse( predict(fit, test[ ,labels]) > 0.5, 1, 0 ))
    }
  })
}

x = Algo$adaboost(SETS$train, SETS$test, 100, tree);

Utils$asses(SETS$test$spam , x);

print('--------------------------------');

p = tree(SETS$train)(SETS$test);

Utils$asses(SETS$test$spam, p);