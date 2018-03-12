ROOT = 'repos/dit/ml/'

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('C50', 'dataQualityR', 'dplyr', 'ggplot2'));