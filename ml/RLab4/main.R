ROOT = paste(getwd(), '/repos/dit/', sep = '');

source(paste(ROOT, 'ml/utils/Setup.R', sep=''));

Setup$getPkgs('dplyr');

DATA <- read.csv(
      paste(ROOT, 'datasets/SMSSpanCollection.txt', sep='')
    , stringsAsFactors = FALSE, sep=",", quote="\'"
  ) %>% select(1:2);

colnames(DATA) <- c('text', 'label');