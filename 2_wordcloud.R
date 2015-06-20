# 20/06/2015
# Dom Bennett
# Building a wordcloud with abstracts

# DIRS
data.dir <- '1_parsed'
out.dir <- '2_clouds'
if (!file.exists (out.dir)) {
  dir.create(out.dir)
}

# LIBS
# use install.packages([NAME OF PACKAGE])
library(wordcloud)
library(tm)

# WORDCLOUD
# create corpus
corp <- VCorpus (DirSource ('1_parsed'))
# sort chracters
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, function(x)removeWords(x,stopwords()))
# create terms matrix
term.matrix <- TermDocumentMatrix(corp)
term.matrix <- as.matrix(term.matrix)
comparison.cloud(term.matrix,max.words=100,random.order=FALSE,
                 colors=brewer.pal(8, 'Dark2'))
commonality.cloud(term.matrix,max.words=100,random.order=FALSE,
                  colors=brewer.pal(8, 'Dark2'))

# get top 100 -- TODO softcode
sorted.lpi <- sort(term.matrix[,1], TRUE)
sorted.predicts <- sort(term.matrix[,3], TRUE)
comp.table <- data.frame (lpi.count=sorted.lpi,
                          lpi.words=names (sorted.lpi),
                          predicts.count=sorted.predicts,
                          predicts.words=names (sorted.predicts))
write.table (comp.table[1:100,], file='top_hundred.txt',
             quote=FALSE, row.names=FALSE, col.names=FALSE)
