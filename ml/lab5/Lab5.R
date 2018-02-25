#############################################################
# INITIALIZATION: tidyverse required
#############################################################

if (!require('tidyverse')) {
  install.packages('tidyverse');
}
library(tidyverse);

###########################################################################
# FACTORY: K-nearest algorithms with parametrized distance and strategies.
###########################################################################

lab = (function (name, dist) {

  # All strategies available.
  strategies = c(
    'random' = function (df, k) {
      return (df[sample(nrow(df), 1), ]['target']);
    },
    'common' = function (df, k) {
      return ((df[ , 'target'] %>% sum) > round(k/2));
    }
  );
  
  # All distances available
  distances = c(
    'euclid' = function (x, y) {
      return (sqrt(sum((x -y )^2)))
    }, 
    'manhattan' = function (x, y) {
      return (sum( abs(x -y)))
    }
  )
  
  # Pick one!
  
  d = get(dist, distances);
  strategy = get(name, strategies);
  
  knearest <- function (df, target, k, instance) {
    
    data = df[ , - which(names(test) == target) ];
    distances = NULL;
    
    for (index in 1:nrow(data)) {
      distances[index] = d(data[index, ], instance);
    }
    
    data['distances'] = distances;
    data['target'] = df['target'];
    data = arrange(data, distances);
    
    return (strategy(data[1:k, ], k));
  }  
  
  return (knearest);
  
})('common', 'euclid') # Change this to change distance or strategy.

###########################################################################
# MAIN: K-nearest algorithms for question 1
###########################################################################

Question1 = data.frame(
  'wave_size' = c(6, 1, 7, 7, 2, 10), 
  'wave_period' = c(15, 6, 10, 12, 2, 2), 
  'win_speed' = c(5, 9, 4, 3, 10, 20), 
  'target' = c(T, F, T, T, F, F)
);

print('Applying k-nearest to [0, 0, 0] with k=4')
print(lab(test, 'target', 1, c(8, 2, 18) ))