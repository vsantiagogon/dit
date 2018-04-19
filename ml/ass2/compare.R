ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));

Utils$getPkgs('lsr');

singleton = read.csv(paste(ROOT, 'datasets/trees/add_single.csv', sep = ''));
enssemble = read.csv(paste(ROOT, 'datasets/trees/add_enssemble.csv', sep = ''));

shapiro.test(singleton$Prec);
shapiro.test(singleton$Acc);
shapiro.test(enssemble$Prec);
shapiro.test(enssemble$Acc);

####################################################################################
# COMPARE PRECISSION
####################################################################################


t.test(singleton$Prec, enssemble$Prec, paired = TRUE);

cohensD(singleton$Prec, enssemble$Prec);

####################################################################################
# COMPARE ACCURACY
####################################################################################

t.test(singleton$Acc, enssemble$Acc, paired = TRUE);

cohensD(singleton$Acc, enssemble$Acc);