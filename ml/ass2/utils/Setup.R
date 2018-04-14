Setup = (function (path) {
  
  data = '';
  
  return (list(
    
    getPkgs = function (pkgs) {
      for (pkg in pkgs) {
        if (!(pkg %in% installed.packages())) install.packages(pkg);
        library(pkg, character.only = T);
      } 
    },
    
    normalize = function(x) { 
      return ((x - min(x)) / (max(x) - min(x))) 
    },
    
    split = function (df, percentage = 0.7) {
      split = sample(nrow(df), floor(percentage*nrow(DATA)));
      return (list(
        train = df[split, ],
        test  = df[-split, ]
      ));
    },
    
    getData = function (path) {
      return (read.csv(path));
    }
  ))
  
})()

