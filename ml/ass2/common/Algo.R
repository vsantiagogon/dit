
Algo = (function (path) {
  
  return (list(
    
    bagging = function (fn, train, test, iterations, length) {
      
      labels = setdiff(names(train), 'spam');
      
      cl <- makeCluster(detectCores());
      registerDoParallel(cl);
      
      predictions <- foreach(m = 1 : iterations, .combine = cbind) %dopar% {
        
        sample = sample(nrow( train ), size = floor((nrow( train )/ 20)));
        predictions <- fn(train[sample, ], test);
      }
      stopCluster(cl);
      
      return (rowMeans(predictions));
    }
    
  ))
  
})()