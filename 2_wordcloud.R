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
corp <- VCorpus (DirSource (1_parsed))
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
