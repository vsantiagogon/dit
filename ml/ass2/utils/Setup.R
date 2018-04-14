Setup = (function (path) {
  
  data = '';
  
  return (list(
    
    getPkgs = function (pkgs) {
      for (pkg in pkgs) {
        if (!(pkg %in% installed.packages())) install.packages(pkg);
        library(pkg, character.only = T);
      } 
    },
    
    split = function (df, percentage = 0.7) {
      split = sample(nrow(df), floor(percentage*nrow(DATA)));
      return (list(
        train = df[split, ],
        test  = df[-split, ]
      ));
    },
    
    bagging = function (fn, train, test, iterations, length) {
      
      labels = setdiff(names(train), 'spam');
      
      cl <- makeCluster(detectCores());
      registerDoParallel(cl);
      
      predictions <- foreach(m = 1 : iterations, .combine = cbind) %dopar% {
        
        sample = sample(nrow( train ), size = floor((nrow( train )/ 20)))
        model <- fn(spam ~ ., data = train[sample, ] );
        predictions <- ifelse( predict(model, test[, labels]) > 0.5, 1, 0);
      }
      stopCluster(cl);
      
      return (rowMeans(predictions));
    }
    
    
  ))
  
})()

