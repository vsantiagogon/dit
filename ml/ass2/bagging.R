ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));
source(paste(ROOT, 'common/Algo.R', sep = ''));

Utils$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr', 'SDMTools'));

DATA = read.csv(paste(ROOT, 'dataset/spam.csv', sep = ''));
DATA = DATA[sample(nrow(DATA)), ];

SETS = Utils$split(DATA);

##########################################################################
# SINGLE MODEL
##########################################################################

fn = lm; # Model in use. rpart || lm

labels = names(SETS$train) %>% setdiff('spam'); 
fit    = fn(spam ~ ., data = SETS$train);
preds  = ifelse(predict(fit, SETS$test[, labels]) > 0.5, 1, 0);

##########################################################################
# BAGGING
##########################################################################

bagged_preds = Algo$bagging(fn, SETS$train, SETS$test, 400, 20);

##########################################################################
# COMPARE
##########################################################################

auc(SETS$test$spam, preds) %>% print;
auc(SETS$test$spam, bagged_preds ) %>% print;


Utils$asses(SETS$test$spam, bagged_preds);
print('----------------------------------------')
Asses(SETS$test$spam, preds);
