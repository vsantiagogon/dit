ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('foreach', 'doParallel', 'pROC', 'dplyr', 'caret'));

cl <- makeCluster(detectCores());

registerDoParallel(cl);

DATA = Setup$getData(paste(ROOT, 'dataset/spam.csv', sep = ''))

SETS = Setup$split(DATA);
labels <- setdiff(names(SETS$train), 'spam');

predictions <- foreach(m = 1: 400, .combine = cbind) %dopar% {
  sample = sample(nrow(SETS$train), size=floor((nrow(SETS$train)/ 20)))
  model <- lm(spam ~ ., data = SETS$train[sample, ]);
  predictions  <- data.frame( predict( model, SETS$test[, labels]) );
}
stopCluster(cl);

auc(SETS$test$spam, rowMeans(ifelse(predictions > 0.5, 1, 0)) ) %>% print;

m <- lm(spam ~ ., data = SETS$train);
p <- ifelse( predict(model, SETS$test[, labels]) > 0.5, 1, 0);

auc(SETS$test$spam, p) %>% print;

