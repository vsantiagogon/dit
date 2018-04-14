ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr'));

DATA = read.csv(paste(ROOT, 'dataset/spam.csv', sep = ''));
DATA = DATA[sample(nrow(DATA)), ];

SETS = Setup$split(DATA);

##########################################################################
# SINGLE MODEL
##########################################################################

fn = rpart; # Model in use.

labels = names(SETS$train) %>% setdiff('spam'); 
fit    = fn(spam ~ ., data = SETS$train);
preds  = ifelse(predict(fit, SETS$test[, labels]) > 0.5, 1, 0);

##########################################################################
# BAGGING
##########################################################################

bagged_preds = Setup$bagging(fn, SETS$train, SETS$test, 400, 20);

##########################################################################
# COMPARE
##########################################################################

auc(SETS$test$spam, preds) %>% print;
auc(SETS$test$spam, bagged_preds ) %>% print;
