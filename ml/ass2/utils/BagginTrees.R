ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('foreach', 'doParallel', 'rpart',  'pROC', 'dplyr', 'caret'));

cl <- makeCluster(detectCores());
DATA = Setup$getData(paste(ROOT, 'dataset/spam.csv', sep = ''))

SETS = Setup$split(DATA);
labels <- setdiff(names(SETS$train), 'spam');

##########################################################################
# BAGGING WITH TREES.
##########################################################################

fit   <- rpart(spam ~ ., data=SETS$train, method="class");
probs <- predict(fit, SETS$test[, labels], method='class');
pre   <- ifelse(probs[, 2] - probs[ , 1] > 0, 1, 0);

auc(SETS$test$spam, pre) %>% print;


registerDoParallel(cl);

predictions <- foreach(m = 1: 4, .combine = cbind) %dopar% {
  Setup$getPkgs('rpart');
  sample = sample(nrow(SETS$train), size=floor((nrow(SETS$train)/ 20)))
  model <- rpart(spam ~ ., data=SETS$train[sample, ], method="class");
  probs <- predict(model, SETS$test[, labels]);
  predictions  <- data.frame( ifelse(probs[, 2] - probs[, 1] > 0, 1, 0) );
}
stopCluster(cl);

auc(SETS$test$spam, rowMeans(ifelse(predictions > 0.5, 1, 0)) ) %>% print;
