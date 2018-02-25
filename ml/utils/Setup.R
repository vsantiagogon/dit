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
    
    split = function (df, id) {
      
      # Randomize
      data = df[sample(1:nrow(df)), ]
      
      # Split 70/30
      train = head(data, round(0.7 * nrow(data)));
      test  = tail(data, nrow(data) - round(0.7 * nrow(data)));
      
      # Return the data oredered by ID.
      return (list(
        'train' = train[order(train[id]), ],
        'test'  = test[order(test[id]), ]
      ))
      
    }
  
  ))
  
})()

