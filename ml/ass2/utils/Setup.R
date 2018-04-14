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
    
    getData = function (path) {
      return (read.csv(path));
    }
  ))
  
})()

