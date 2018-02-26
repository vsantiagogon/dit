source('repos/dit/ml/utils/Setup.R');

# Load the dataset & dependencies
DATA = read.csv('repos/dit/datasets/Titanic.csv', na.strings = 'NA');

Setup$getPkgs(c('ggplot2', 'dplyr'));

# Categorical variables vs Survived.

ggplot( DATA, aes(Sex, fill=Sex) ) + geom_bar() + facet_grid(~ as.logical(Survived))

ggplot( DATA, aes(Pclass, fill=Pclass) ) + geom_bar() + facet_grid(~ as.logical(Survived))

ggplot( DATA, aes(Embarked, fill=Embarked) ) + geom_bar() + facet_grid(~ as.logical(Survived))

# Continuous variables relationships.
ggplot(DATA, aes(x = Age, y = Fare)) + geom_point() + theme_classic();

# Continuous variables vs Survived
qplot( DATA$Age, geom="histogram", xlab='Age', fill=I('lightblue'), col=I('white')) + theme_classic(); 
qplot( DATA[DATA$Survived == 0, ]$Age, geom="histogram", xlab='Age', main='Survivors by age', fill=I('lightblue'), col=I('white')) + theme_classic();
qplot( DATA[DATA$Survived == 1, ]$Age, geom="histogram", xlab='Age', main='Non-survivors by age', fill=I('lightblue'), col=I('white')) + theme_classic();


qplot( DATA$Fare, geom="histogram", xlab='Fare', fill=I('lightblue'), col=I('white')) + theme_classic(); 
qplot( DATA[DATA$Survived == 0, ]$Fare, geom="histogram", xlab='Fare', main='Survivors by Fare', fill=I('lightblue'), col=I('white')) + theme_classic();
qplot( DATA[DATA$Survived == 1, ]$Fare, geom="histogram", xlab='Fare', main='Non-survivors by Fare', fill=I('lightblue'), col=I('white')) + theme_classic();