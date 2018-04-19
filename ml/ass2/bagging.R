ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));
source(paste(ROOT, 'common/Algo.R', sep = ''));

Utils$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr', 'SDMTools', 'curry'));

DATA = read.csv(paste(ROOT, 'datasets/spam.csv', sep = ''));

linear <- function (train, test) {
  
  labels = setdiff(names(train), 'spam'); 
  fit    = glm(spam ~ ., data = train);
  preds  = ifelse( predict(fit, test[ , labels], type='response') > 0.5, 1, 0);
  return(preds);
}

tree <- function (train, test) {
  library('rpart');
  labels = setdiff(names(train), 'spam'); 
  fit    = rpart(spam ~ ., data = train);
  preds  = ifelse( predict(fit, test[ , labels]) > 0.5, 1, 0);
  return(preds);
}

use = linear;

singleton = data.frame();
enssemble = data.frame();

for (i in 1:100) {
  print(i);
  DATA = DATA[sample(nrow(DATA)), ];
  SETS = Utils$split(DATA);
  
  preds     = use(SETS$train, SETS$test);
  results   = Utils$asses(SETS$test$spam, preds);
  singleton = rbind(singleton, results);
  
  preds     = Algo$bagging(use, SETS$train, SETS$test, 400, 2);
  results   = Utils$asses(SETS$test$spam, preds);
  enssemble = rbind(enssemble, results);
}

names(singleton) = c('Prec', 'Acc'); 
names(enssemble)    = c('Prec', 'Acc');

write.csv(singleton, paste(ROOT, 'datasets/bagging_single.csv', sep = ''));
write.csv(enssemble, paste(ROOT, 'datasets/bagging_enssemble.csv', sep = ''));
