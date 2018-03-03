ROOT = 'repos/dit/ml/'

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('C50', 'dataQualityR', 'dplyr', 'ggplot2'));

DATA = read.csv(paste(ROOT, '../datasets/UCI_Credit_Card.csv', sep = ''), stringsAsFactors = F);

source( paste( ROOT, 'RLab2/quality.R', sep = '' ) );

# DATA QUALITY REPORT.
Report <- DQ(DATA);
View(Report$Num)

# Show continuous relations. 

# DRAW ALL CONTINUOUS VARIABLES RELATIONS. 
# subset(DATA, select = -c(ID, MARRIAGE, EDUCATION, SEX, PAY_0, PAY_2, PAY_3, PAY_4, PAY_5, PAY_6, default.payment.next.month)) %>% pairs(upper.panel = Setup$cors);

# DRAW ALL BILL_* VARIABLES RELATIONS.
# select(DATA, BILL_AMT1, BILL_AMT2, BILL_AMT3, BILL_AMT4, BILL_AMT5, BILL_AMT6) %>% pairs( upper.panel = Setup$cors );

# DRAW ALL PAY_* VARIABLES RELATIONS.
# select(DATA, PAY_AMT1, PAY_AMT2, PAY_AMT3, PAY_AMT4, PAY_AMT5, PAY_AMT6) %>% pairs( upper.panel = Setup$cors );

# MARRIAGE, EDUCATION AND SEX vs TARGET.

# SEX vs TARGET
ggplot( DATA, aes(SEX, fill=SEX) ) + 
  geom_bar() + 
  facet_grid(~ as.logical(default.payment.next.month)) +
  theme_classic();

# EDUCATION vs TARGET
ggplot( DATA, aes(EDUCATION, fill=EDUCATION) ) + 
  geom_bar() + 
  facet_grid(~ as.logical(default.payment.next.month)) +
  theme_classic();

# MARRIAGE vs TARGET
ggplot( DATA, aes(MARRIAGE, fill=MARRIAGE) ) + 
  geom_bar() + 
  facet_grid(~ as.logical(default.payment.next.month)) +
  theme_classic();

# AGE vs TARGET
qplot( DATA$AGE, geom="histogram", xlab='AGE', fill=I('lightblue'), col=I('white')) + theme_classic(); 
qplot( DATA[DATA$default.payment.next.month == 0, ]$AGE, geom="histogram", xlab='AGE', main='TARGET = 0', fill=I('lightblue'), col=I('white')) + theme_classic();
qplot( DATA[DATA$default.payment.next.month == 1, ]$AGE, geom="histogram", xlab='AGE', main='TARGET = 1', fill=I('lightblue'), col=I('white')) + theme_classic();

# BILL_AMT1 vs TARGET
qplot( DATA$BILL_AMT1, geom="histogram", xlab='BILL_AMT1', fill=I('lightblue'), col=I('white')) + theme_classic(); 
qplot( DATA[DATA$default.payment.next.month == 0, ]$BILL_AMT1, geom="histogram", xlab='AGE', main='TARGET = 0', fill=I('lightblue'), col=I('white')) + theme_classic();
qplot( DATA[DATA$default.payment.next.month == 1, ]$BILL_AMT1, geom="histogram", xlab='AGE', main='TARGET = 1', fill=I('lightblue'), col=I('white')) + theme_classic();
