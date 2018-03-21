ROOT = paste(getwd(), '/repos/dit/', sep = '');

source(paste(ROOT, 'ml/utils/Setup.R', sep=''));

Setup$getPkgs(c('dplyr', 'tm'));

DATA <- read.csv(paste(ROOT, 'datasets/SMSSpanCollection.txt', sep=''), stringsAsFactors = F, sep=",", quote="\'") %>% 
  select(1:2);

colnames(DATA) <- c('text', 'label');

# Create and clean corpus.
corpus = Corpus(VectorSource(DATA$text)) %>%  # CREATION
  tm_map(tolower) %>%                         # LOWERCASE
  tm_map(removeNumbers) %>%                   # NO NUMBERS ALLOWED
  tm_map(removePunctuation) %>%               # REMOVE PUNCTUATION
  tm_map(stripWhitespace);                    # TRIM WHITESPACES

