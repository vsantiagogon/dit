ROOT = 'repos/dit/ml/'

source(paste(ROOT, 'utils/Setup.R', sep = ''));

Setup$getPkgs(c('C50', 'dataQualityR', 'dplyr'));

DATA = read.csv(paste(ROOT, '../datasets/UCI_Credit_Card.csv', sep = ''), stringsAsFactors = F);

source( paste( ROOT, 'RLab2/quality.R', sep = '' ) );

# Report <- DQ(DATA);
# View(Report$Num) ???

# Show continuous relations. 

#subset(DATA, select = -c(ID, AGE, MARRIAGE, EDUCATION, SEX, PAY_0, PAY_2, PAY_3, PAY_4, PAY_5, PAY_6, default.payment.next.month)) %>% pairs;

# select(DATA, BILL_AMT1, BILL_AMT2, BILL_AMT3, BILL_AMT4, BILL_AMT5, BILL_AMT6) %>% pairs

# select(DATA, PAY_AMT1, PAY_AMT2, PAY_AMT3, PAY_AMT4, PAY_AMT5, PAY_AMT6) %>% pairs
