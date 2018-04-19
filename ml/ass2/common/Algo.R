
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
    },
    
    adaboost = function (train, test, M, clf) {
      n = nrow(train);
      
      w = rep(1/n, n);
      
      train$spam = ifelse(train$spam == 0, -1, 1);
      test$spam  = ifelse(test$spam  == 0, -1, 1);
      
      output = rep(0, nrow(test)); # General model is a sum. We use neutral 0 to initialize
      
      for (i in 1:M) {
        #model      = clf(spam ~ ., data = train, weights = w);
        classifier = clf(train, ada = TRUE, weights = w);
        # We want to modify weights on those points where we find difficulties to predict. 
        # That's why we do this silly thing of calculate predictions over the train dataset.
        preds = classifier(train);
        preds_test = classifier(test);
        
        ind = data.frame(actual = train$spam, preds = preds) %>% mutate(ind = ifelse(actual != preds, 1, 0)) %>% select(ind);
        
        err = sum(w %*% ind[ , 1 ]) / sum(w);
        
        alpha = 0.5 * log( (1 - err )/ err );
        
        w = w * exp(alpha * ind[, 1]);
        
        output = output + c(alpha * preds_test);
      }
      
      return ( sign(output) );
    }
    
  ))
  
})()