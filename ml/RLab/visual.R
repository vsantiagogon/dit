source('repos/dit/ml/utils/Setup.R');

# Load the dataset & dependencies
DATA = read.csv('repos/dit/datasets/Titanic.csv', na.strings = 'NA');

Setup$getPkgs(c('ggplot2'));


# gender suvivors breakdown
ggplot( DATA, aes(Sex, fill=Sex) ) + geom_bar() + facet_grid(~ as.logical(Survived))
