# 20/06/2015
# Dom Bennett
# Building a wordcloud with PREDICTS abstracts

# LIBS
# use install.packages([NAME OF PACKAGE])
library(wordcloud)
library(tm)

# READ AND WRITE DATA
predicts.pubs <- readRDS(file.path ("predicts",
                                    'predicts_bib-2015-06-12-02-45-49.rds'))
if (!file.exists ('abstracts')) {
  dir.create('abstracts')
}
write.table (predicts.pubs$Abstract,
             file.path ('abstracts', 'abstracts.txt'),
             quote=FALSE, row.names=FALSE, col.names=FALSE)
rm(predicts.pubs)

# WORDCLOUD
# create corpus
corp <- VCorpus (DirSource ('abstracts'))
# sort chracters
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, function(x)removeWords(x,stopwords()))
# create terms matrix
term.matrix <- TermDocumentMatrix(corp)
term.matrix <- as.matrix(term.matrix)
colnames(term.matrix) <- c("SOTU 2010","SOTU 2011")
# generate wordcloud
commonality.cloud(term.matrix,max.words=300,random.order=FALSE,
                  colors=brewer.pal(8, 'Dark2'))

# get top 100
sorted.instances <- sort(term.matrix[,1], TRUE)
top.hundred <- sorted.instances[1:100]
top.hundred <- data.frame (word=names(top.hundred),
                           count=top.hundred)
write.table (top.hundred, file='top_hundred.txt',
             quote=FALSE, row.names=FALSE, col.names=FALSE)
