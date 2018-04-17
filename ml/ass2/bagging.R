ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));
source(paste(ROOT, 'common/Algo.R', sep = ''));

Utils$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr', 'SDMTools', 'curry'));

DATA = read.csv(paste(ROOT, 'dataset/spam.csv', sep = ''));
DATA = DATA[sample(nrow(DATA)), ];

SETS = Utils$split(DATA);

learner = list(
  
);

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

weak_learners = tree;

##########################################################################
# SINGLE MODEL
##########################################################################

preds = weak_learners(SETS$train, SETS$test);

##########################################################################
# BAGGING
##########################################################################

bagged_preds = Algo$bagging(weak_learners, SETS$train, SETS$test, 400, 20);

##########################################################################
# COMPARE
##########################################################################

auc(SETS$test$spam, preds) %>% print;
auc(SETS$test$spam, bagged_preds ) %>% print;

print('----------------------------------------')
Utils$asses(SETS$test$spam, preds);
Utils$asses(SETS$test$spam, bagged_preds);
