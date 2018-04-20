####################################################################################
# A set of t-test paired. 
# We want to check if Precission & Accurayc mean difference between enssemble and 
# standalone models are significant.
# 
# The scheme that this script provides will work, no matter if you change the weak 
# learner or the dataset in use. 
#
# Last time I ran it, I used ADABOOST using TREE weak learners. Feel fee to change it.
#
####################################################################################

ROOT = paste(getwd(), '/repos/dit/ml/ass2/', sep = '');

source(paste(ROOT, 'common/Utils.R', sep = ''));

Utils$getPkgs('lsr');

singleton = read.csv(paste(ROOT, 'datasets/trees/ada_single.csv', sep = ''));
enssemble = read.csv(paste(ROOT, 'datasets/trees/ada_enssemble.csv', sep = ''));

# First we check t-test assumptions: They are all normal.

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