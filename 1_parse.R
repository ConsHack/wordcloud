# 20/06/2015
# Dom Bennett
# Parsing abstracts into 'abstracts/'

# DIRS
data.dir <- '0_data'
out.dir <- '1_parsed'
if (!file.exists (out.dir)) {
  dir.create(out.dir)
}

# EXTRACT PREDICTS ABSTRACTS
predicts.pubs <- readRDS(file.path ("predicts",
                                    'predicts_bib-2015-06-12-02-45-49.rds'))
write.table (predicts.pubs$Abstract,
             file.path (out.dir, 'predicts_abstracts.txt'),
             quote=FALSE, row.names=FALSE, col.names=FALSE)
rm(predicts.pubs)

# EXTRACT NON-PREDICTS ABSTRACTS
# read in as lines -- if 'incomplete final line error' add return at bottom of file
raw.data <- readLines (file.path (data.dir, 'non_predicts_abstracts.txt'))
lines <- ''
add <- FALSE
for (line in raw.data) {
  # go through lines removing just abstracts
  if (grepl ('^AB', line)) {
    add <- TRUE
    line <- sub ('AB', '', line)
  }
  if (grepl ('^TC', line)) {
    add <- FALSE
  }
  if (add) {
    lines <- paste (lines, line)
  }
}
write.table (lines, file=file.path (out.dir, 'non_predicts_abstracts.txt'))
rm (raw.data)

# EXTRACT LPI ABSTRACTS
# only needs moving
raw.data <- read.delim (file.path (data.dir, 'lpi_abstracts.txt'))[,1]
write.table (raw.data, file.path (out.dir, 'lpi_abstracts.txt'),
             quote=FALSE, row.names=FALSE, col.names=FALSE)

# EXTRACT PUBMED ABSTRACTS
# USE COPY AND PASTE
# raw.data <- read.delim (file.path (data.dir, 'pubmed_abstracts.txt'))[,1]
# write.table (raw.data, file.path (out.dir, 'pubmed_abstracts.txt'),
#              quote=FALSE, row.names=FALSE, col.names=FALSE)