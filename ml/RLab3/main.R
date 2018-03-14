ROOT = 'repos/dit/ml/'

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('C50', 'dataQualityR', 'dplyr', 'ggplot2'));

DATA = read.csv(paste(ROOT, '../datasets/lab3.csv', sep = ''), stringsAsFactors = FALSE, na.string="?");

source( paste( ROOT, 'RLab2/quality.R', sep = '' ) );

# DATA QUALITY REPORT.
  Report <- DQ(DATA);
  View(Report$Cat);
  View(Report$Num);

# DATA PREPARATION.
  
# NORMALIZED.LOSSESS miss ~20% -> Impute by mean

# Age contains a 22% of NA's. We impute them using the median.
DATA[is.na(DATA$normalized.losses) == T, ]$normalized.losses = mean(as.numeric(DATA$normalized.losses), na.rm = TRUE);
    
# REJECT ROWS IN COLUMNS WITH VERY FEW NA's miss ~2% -> reject NA's.
DATA = filter(DATA, !is.na(bore) & !is.na(num.of.doors) & !is.na(num.of.doors) & !is.na(stroke) & !is.na(horsepower) & !is.na(peak.rpm) & !is.na(price));

# DRAW ALL PAY_* VARIABLES RELATIONS.
select(DATA, normalized.losses, wheel.base, length, width, height, curb.weight, engine.size, fuel.system, bore, compression.ratio, horsepower, peak.rpm, city.mpg, highway.mpg, price) %>% pairs( upper.panel = Setup$cors );
