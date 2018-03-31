#################################################################################
# INITIALISATION, LOADING PACKAGES
#################################################################################

ROOT = paste(getwd(), '/repos/dit/', sep = '');
UTILS = paste(ROOT, 'ml/utils/', sep = '');
DATASETS = paste(ROOT, 'datasets/', sep = '');

source(paste(UTILS, 'Setup.R', sep = ''));

# Load packages.
Setup$getPkgs(c('dataQualityR', 'e1071', 'plyr', 'dplyr', 'ggplot2', 'doMC'));

#doMC is a parallel computing library. It requires initialisation.
registerDoMC(cores = detectCores());


DATA = read.csv(paste(DATASETS, 'automobile.csv', sep = ''), na.strings='?', stringsAsFactors = F) %>%
  as.data.frame;

#################################################################################
# DATA QUALITY REPORT & CLEAN UP
#################################################################################

 num.file <- paste(ROOT, "/dq_num.csv", sep= "");
 cat.file <- paste(ROOT, "/dq_cat.csv", sep= "");
 checkDataQuality(data = DATA, out.file.num=num.file, out.file.cat=cat.file);

# REJECT ROWS IN COLUMNS WITH VERY FEW NA's miss ~2% -> reject NA's.
DATA = filter(DATA, !is.na(bore) & !is.na(num.of.doors) & !is.na(num.of.doors) & !is.na(stroke) & !is.na(horsepower) & !is.na(peak.rpm) & !is.na(price));

# Reject normalized.losses. Too many NA's (20%)
DATA = select(DATA, -normalized.losses);

###############################################################################
# SCATTER PLOTS
###############################################################################
# DRAW CONTINUOUS VARIABLES SCATTERPLOTS
# select(DATA, wheel.base, length, width, height, curb.weight, engine.size, bore, compression.ratio, horsepower, peak.rpm, city.mpg, highway.mpg) %>% pairs( upper.panel = Setup$cors );
# select(DATA, wheel.base, length, width, height, curb.weight) %>% pairs( upper.panel = Setup$cors );
# select(DATA, wheel.base, bore, stroke, horsepower, peak.rpm,compression.ratio, city.mpg) %>% pairs( upper.panel = Setup$cors );
# 
# select(DATA, price, wheel.base, height, bore, stroke, compression.ratio, horsepower, peak.rpm, city.mpg) %>% pairs(upper.panel = Setup$cors);
# 
# ###############################################################################
# # CATEGORICAL AGAINST PRICE
# ###############################################################################
# 
# # make, fuel.type, aspiration, num.of.doors, body.style, drive.wheels, engine.location, engine.type, num.of.cylinders, fuel.system
# 
# # price vs symboling
# qplot( DATA$price, geom="histogram", xlab='PRICE', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$symboling == -3, ]$price, geom="histogram", xlab = 'PRICE', main='SYM = -3', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$symboling == -2, ]$price, geom="histogram", xlab = 'PRICE', main='SYM = -2', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$symboling == -1, ]$price, geom="histogram", xlab = 'PRICE', main='SYM = -1', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$symboling ==  0, ]$price, geom="histogram", xlab = 'PRICE', main='SYM =  0', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$symboling ==  1, ]$price, geom="histogram", xlab = 'PRICE', main='SYM =  1', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$symboling ==  2, ]$price, geom="histogram", xlab = 'PRICE', main='SYM = 2', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$symboling ==  3, ]$price, geom="histogram", xlab = 'PRICE', main='SYM = 3', fill=I('lightblue'), col=I('white')) + theme_classic();
# 
# # price vs fuel.type
# qplot( DATA[DATA$fuel.type == 'diesel', ]$price, geom="histogram", xlab = 'PRICE', main='FUEL.TYPE = diesel', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$fuel.type == 'gas', ]$price, geom="histogram", xlab = 'PRICE', main='FUEL.TYPE = gas', fill=I('lightblue'), col=I('white')) + theme_classic();
# 
# # price vs aspiration
# qplot( DATA[DATA$aspiration == 'std', ]$price, geom="histogram", xlab = 'PRICE', main='ASPIRATION = std', fill=I('lightblue'), col=I('white')) + theme_classic();
# qplot( DATA[DATA$aspiration == 'turbo', ]$price, geom="histogram", xlab = 'PRICE', main='ASPIRATION = turbo', fill=I('lightblue'), col=I('white')) + theme_classic();

###############################################################################
# PARTITION & MODEL
###############################################################################

train = DATA[1:(nrow(DATA)*.7), ];
test  = DATA[(nrow(DATA)*.7  + 1):nrow(DATA), ];

model = lm(price ~ symboling + wheel.base + height + bore + horsepower + city.mpg, data = train);
predictions <- predict(model, test);


