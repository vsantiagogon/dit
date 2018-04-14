Utils = (function (path) {

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
    }
    
  ))
  
})()