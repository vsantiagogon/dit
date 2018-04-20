##############################################################################################
# 100 executions of ADABOOST
# The weak learner in use is parametrized.
##############################################################################################

ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));
source(paste(ROOT, 'common/Algo.R', sep = ''));

Utils$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr', 'SDMTools'));

DATA = read.csv(paste(ROOT, 'datasets/spam.csv', sep = ''));
DATA = DATA[sample(nrow(DATA)), ];

SETS = Utils$split(DATA);

# This function is curryfied!!!
tree = function (train, weights = c(), ada = FALSE) {
  labels = setdiff(names(train), 'spam');
  library('rpart')
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


# This function is curryfied!!!
linear = function (train, weights = c(), ada = FALSE) {
  labels = setdiff(names(train), 'spam');
  
  if (ada) {
    train$spam = ifelse(train$spam == -1, 0, 1);
    fit = glm(spam ~., data = train, weights = weights)
  } else {
    fit = glm(spam ~ ., data = train);
  }
  
  return (function (test) {
    if (ada) {
      test$spam = ifelse(test$spam == -1, 0, 1);
      return (ifelse( predict(fit, test, type = 'response') > 0.5, 1, -1))
    } else {
      return (ifelse( predict(fit, test, type = 'response') > 0.5, 1, 0))
    }
  });
  
}

use = tree; # Last time I ran it, I used Tree weak learners. Change it.

singleton = data.frame();
enssemble = data.frame();

for (i in 1:100) {
  print(i);
  DATA = DATA[sample(nrow(DATA)), ];
  SETS = Utils$split(DATA);
  
  preds     = use(SETS$train)(SETS$test);
  results   = Utils$asses(SETS$test$spam, preds);
  singleton = rbind(singleton, results);
  
  preds     = Algo$adaboost(SETS$train, SETS$test, 100, use);
  results   = Utils$asses(SETS$test$spam, preds);
  enssemble    = rbind(enssemble, results);
  
}

names(singleton) = c('Prec', 'Acc');
names(enssemble) = c('Prec', 'Acc');

write.csv(singleton, paste(ROOT, 'datasets/ada_single.csv', sep = ''));
write.csv(enssemble, paste(ROOT, 'datasets/ada_enssemble.csv', sep = ''));