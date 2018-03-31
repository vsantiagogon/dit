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
      
    },
    
    getMode = function(v) {
      uniqv = unique(v)
      uniqv[which.max(tabulate(match(v, uniqv)))]
    },
    
    cors = function(x, y, digits = 2, cex.cor, ...) {
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      # correlation coefficient
      r <- cor(x, y)
      txt <- format(c(r, 0.123456789), digits = digits)[1]
      txt <- paste("r= ", txt, sep = "")
      text(0.5, 0.6, txt)
      
      # p-value calculation
      p <- cor.test(x, y)$p.value
      txt2 <- format(c(p, 0.123456789), digits = digits)[1]
      txt2 <- paste("p= ", txt2, sep = "")
      if(p<0.01) txt2 <- paste("p= ", "<0.01", sep = "")
      text(0.5, 0.4, txt2)
    }
  
  ))
  
})()

