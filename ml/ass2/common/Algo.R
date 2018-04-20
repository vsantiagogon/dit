####################################################################################
# ALGO 
# Adaboost & Bagging implementations
####################################################################################

Algo = (function (path) {
  
  return (list(
    
    
    # Baggin algorithm
    
    # Input: 
    #   fn -> weak learner in use
    #   train -> train dataset
    #   test  -> test dataset
    #   iterations -> number of bagging iterations
    #   length -> size of each "bag"
    
    bagging = function (fn, train, test, iterations, length) {
      
      labels = setdiff(names(train), 'spam');
      
      cl <- makeCluster(detectCores());
      registerDoParallel(cl);
      
      predictions <- foreach(m = 1 : iterations, .combine = cbind) %dopar% {
        # Generate a sub-sample
        sample = sample(nrow( train ), size = floor((nrow( train )/ 20)));
        # train on the sub-sample
        predictions <- fn(train[sample, ], test);
      }
      stopCluster(cl);
      
      return (rowMeans(predictions));
    },
    
    # AdaBoost
    
    # Inputs: 
    #   train -> train dataset
    #   test  -> test dataset
    #   M     -> How many weak learners are we going to use
    #   clf   -> weak learner in use
    
    adaboost = function (train, test, M, clf) {
      n = nrow(train);
      
      w = rep(1/n, n); # Initialising weights.
      
      # Adaboost needs to predict {-1, 1} instead of {0, 1}
      train$spam = ifelse(train$spam == 0, -1, 1);
      test$spam  = ifelse(test$spam  == 0, -1, 1);
      
      output = rep(0, nrow(test)); # General model is a sum. We use neutral 0 to initialize
      
      for (i in 1:M) {
        # We train a weighted classifier
        classifier = clf(train, ada = TRUE, weights = w);
        
        # Adaboost improves predictions by training each weak learner focusing on 
        # the worst performing data points of the previous one.
        preds = classifier(train);
        preds_test = classifier(test);
        
        # Indicator function. 
        ind = data.frame(actual = train$spam, preds = preds) %>% mutate(ind = ifelse(actual != preds, 1, 0)) %>% select(ind);
        
        # Calculate the error.
        err = sum(w %*% ind[ , 1 ]) / sum(w);
        
        # alpha describes the weight of "this" classifier in the overall model.
        alpha = 0.5 * log( (1 - err )/ err );
        
        # At this point we know how bad we are. Let's update the weights to force 
        # the next learner get the best out of our current weakenesses.
        w = w * exp(alpha * ind[, 1]);
        
        # We use alpha to append our learning at this step
        output = output + c(alpha * preds_test);
      }
      
      return ( sign(output) ); # Yep, {-1, 1} instead of {0, 1}
    }
  ))
  
})()