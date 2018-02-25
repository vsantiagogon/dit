# Baseline model: including only numeric features.

base_model = function(data) {
  
  Setup$getPkgs(c('class', 'dplyr'))
  
  ### DATA PREPARATION
  
  data = select(data, c('PassengerId', 'Survived', 'Age', 'Fare'));
  
  # Age contains a 22% of NA's. We impute them using the median.
  data[is.na(data$Age) == TRUE, ]$Age = mean(data$Age, na.rm = TRUE);
  
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