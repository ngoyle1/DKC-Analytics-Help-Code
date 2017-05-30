remove(list = ls())
library(twitteR)
library(httr)
library(SnowballC)
library(httpuv)
library(dplyr)
library(tm)

setup_twitter_oauth("R9R5ic0jM3UjHs38PXIArUG1y", "xRYZ8em8ScFD5CCi9kOkomGbhPxPysNH4f4Z2nvO449XNvC7mg")
luis <- userTimeline("LuisMarcanth", n = 3200, includeRts = TRUE)
luis_df <-twListToDF(luis)
luis_self <- filter(luis_df, isRetweet == FALSE)
luis_corpus <- Corpus(VectorSource(luis_self$text)) ##this creates a list of the tweets


miningCases <- lapply(luis_corpus,function(x) { grep(as.character(x), pattern = "\\<harrocyranka")} ) ##conta os padrões
sum(unlist(miningCases)) ##Conta o número de vezes

removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
myCorpus <- tm_map(luis_corpus, content_transformer(removeURL))
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))
tdm <- TermDocumentMatrix(myCorpus, control = list(wordlenghts = c(1,Inf))) ##Creates a TextDocumentMatrix

association <- which(dimnames(tdm)$Terms == "harrocyranka")
inspect(tdm[association + (0:5), 101:110])

(frequent_words <- findFreqTerms(tdm, lowfreq = 20)) ##findFreqTerms MUST be all enclosed in parentheses
frequent_words <- rowSums(as.matrix(tdm))
frequent_words <- subset(frequent_words, frequent_words >= 15)
df <- data.frame(term = names(frequent_words), freq = frequent_words)
df <- arrange(df,desc(freq))
top_30 <- subset(df[1:30,])

library(ggplot2)
ggplot(top_30, aes(x = term, y = freq)) + geom_bar(stat = "identity") +
  xlab("Palavra") + ylab("Count") + coord_flip() + scale_x_discrete(limits = top_30$term)

findAssocs(tdm,"harrocyranka",0.2)
findAssocs(tdm,"dream",0.2)
findAssocs(tdm,"rio",0.2)
findAssocs(tdm, "joe", 0.2)
findAssocs(tdm, "brunalofrano", 0.2)
findAssocs(tdm, "disney", 0.2)


disney_count <- lapply(luis_corpus,function(x) { grep(as.character(x), pattern = "\\<disney")} )
sum(unlist(disney_count)) ##Conta o número de vezes

##Word Cloud##
library("wordcloud")
m <- as.matrix(tdm)
word_freq <- sort(rowSums(m), decreasing = T)
pal <- brewer.pal(9, "BuGn")
pal <- pal[-(1:4)]

wordcloud(words = names(word_freq), freq = word_freq, min.freq = 20,random.order = F, colors = pal)