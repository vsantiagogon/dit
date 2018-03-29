########################################################################################
# INITIALISATION, LOADING PACKAGES.
########################################################################################

ROOT  = paste(getwd(), '/repos/dit/', sep='');
UTILS = paste(ROOT, 'ml/utils/', sep = '');
DATASETS = paste(ROOT, 'datasets/', sep = '');
  
source(paste(UTILS, 'Setup.R', sep = ''));

# Load packages.
Setup$getPkgs(c('tm', 'RTextTools', 'wordcloud', 'e1071', 'dplyr', 'caret', 'doMC'));

#doMC is a parallel computing library. It requires initialisation.
registerDoMC(cores = detectCores());

DATA <- read.csv(paste(ROOT, 'datasets/SMSSpanCollection.txt', sep=''), stringsAsFactors = F, sep=",", quote="\'") %>% 
  select(1:2);

colnames(DATA) <- c('text', 'class');

########################################################################################
# DATA CLEANUP
########################################################################################

# Remove inconsistent values
DATA = filter(DATA, !(class != '0' & class != '1'));

# Convert class to a factor.
DATA$class = as.factor(DATA$class);

########################################################################################
# BAG OF WORDS
########################################################################################
# Create corpus
corpus = Corpus(VectorSource(DATA$text));

# Data clean up.

corpus.clean = corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords( kind = "en" )) %>%
  tm_map(stripWhitespace);

DTM = DocumentTermMatrix(corpus.clean);

########################################################################################
# PARTITION 
########################################################################################

data.train = DATA[1:(round(nrow(DATA)*.75)), ];
data.test  = DATA[(round(nrow(DATA)*.75) + 1): nrow(DATA), ];

dtm.train = DTM[1:(round(nrow(DATA)*.75)), ];
dtm.test  = DTM[(round(nrow(DATA)*.75) + 1): nrow(DATA), ];

corpus.clean.train = corpus.clean[1:(round(nrow(DATA)*.75))];
corpus.clean.test  = corpus.clean[(round(nrow(DATA)*.75) + 1): nrow(DATA)];

# Reducing less frequent features

freq = findFreqTerms(dtm.train, 5); 

dtm.train.nb = DocumentTermMatrix(corpus.clean.train, control = list(dictionary = freq));
dtm.test.nb  = DocumentTermMatrix(corpus.clean.test, control = list(dictionary = freq));

convert_count <- function(x) {
  return ( ifelse(x > 0, 1,0) %>% factor(levels = c(0, 1), labels = c('No', 'Yes')) );
}

trainNB = apply(dtm.train.nb, 2, convert_count);
testNB  = apply(dtm.test.nb, 2, convert_count);

########################################################################################
# TRAIN & PREDICT 
########################################################################################

classifier = naiveBayes(trainNB, data.train$class, laplace = 1);

predictions = predict(classifier, newdata = testNB);

conf.mat = confusionMatrix(predictions, data.test$class);

conf.mat

########################################################################################
# CREATING WORDCLOUD 
########################################################################################

wordcloud(corpus.clean.train, min.freq=40, random.order=F);
