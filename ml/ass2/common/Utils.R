Utils = (function (path) {

  return (list(
    
    # Install if not exists. Then load.
    getPkgs = function (pkgs) {
      for (pkg in pkgs) {
        if (!(pkg %in% installed.packages())) install.packages(pkg);
        library(pkg, character.only = T);
      } 
    },
    
    # Split any dataframe into TRAIN & TEST datasets
    split = function (df, percentage = 0.7) {
      split = sample(nrow(df), floor(percentage*nrow(DATA)));
      return (list(
        train = df[split, ],
        test  = df[-split, ]
      ));
    },
    
    # Calculate Precission & Accuracy from confussion matrix.
    asses = function (test, pred) {
      # Finally, we show the results, using the confusion matrix.
      mat = confusion.matrix(test, pred)
      TN = mat[1, 1]
      TP = mat[2, 2]
      FN = mat[1, 2]
      FP = mat[2, 1]
      TOTAL = TP + TN + FN + FP;
      
      Accuracy = (TP + TN)/TOTAL
      Precision = TP / (TP + FP); 
      MisRate  = (FP + FN) / TOTAL
      
      return (c(Precision, Accuracy))
      
    }
    
  ))
  
})()