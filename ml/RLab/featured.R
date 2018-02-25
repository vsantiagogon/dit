
# Model after feature selection.

feat_model = function(data) {
  
  Setup$getPkgs(c('class', 'dplyr'))
  
  ### DATA PREPARATION

  # Obvious drops
  data = subset(data, select = -c(Name, Ticket))

  # Cabin has a ~77% of missing values. We drop it as well.
  data = subset(data, select = -c(Cabin))

  # Only 0.22% of missing values in Embarked column. We'll drop the rows with NA's.
  data = filter(data, Embarked != '');

  # Age contains a 22% of NA's. We impute them using the median.
  data[is.na(data$Age) == TRUE, ]$Age = mean(data$Age, na.rm = TRUE);

  # Normalization, type conversions. 
  data$Sex = sapply(as.character(data$Sex), switch, 'male' = 0, 'female' = 1);
  data$Embarked = sapply(as.character(data$Embarked), switch, 'C' = 0, 'Q' = 1, 'S' = 2);
  data = as.data.frame(lapply(data, Setup$normalize));
  
  ### KNN

  # Randomize the data
  ds = Setup$split(data, 'PassengerId');
  
  # OK, ready to run
  predictions <- data.frame(
    'ID' = ds$test$PassengerId,
    'Survived' = knn(
      select(ds$train, -c(PassengerId, Survived)), 
      select(ds$test, -c(PassengerId, Survived)), 
      ds$train$Survived, 
      k=10, 
      l=0
    )
  ) %>% arrange(ID)
  
  return (list(
    test = ds$test$Survived,
    pred = predictions$Survived
  ))
  
}