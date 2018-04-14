ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('foreach',  'doParallel', 'rpart',  'pROC', 'dplyr'));

DATA = read.csv(paste(ROOT, 'dataset/spam.csv', sep = ''));
DATA = DATA[sample(nrow(DATA)), ];

SETS = Setup$split(DATA);
