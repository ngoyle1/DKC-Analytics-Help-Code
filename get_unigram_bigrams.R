get_unigram <- function(file_with_description,file_to_write){
    library(tm)
    library(xlsx)
    library(dplyr)
    x <- read.csv(file_with_description, header = TRUE)
    
    ##Eliminating Multibyte##
    filter <- grep("I_WAS_NOT_ASCII", iconv(x$description, "latin1", "ASCII", sub="I_WAS_NOT_ASCII"))
	  x <- x[-filter,]
    ##
    common_words <- read.xlsx("/Users/harrocyranka/Desktop/code/freq_english_words.xlsx", sheetIndex = 1)
    trim <- function (x) gsub("^\\s+|\\s+$", "", x)
    x$description <- enc2native(x$description)
    
    x$description <- trim(gsub("[^[:alnum:] ]", " ", tolower(x$description)))
    x$description <- trim(gsub("\\s{2,20}"," ", x$description))
    x$description <- removePunctuation(x$description)
    x$description <- removeWords(x$description, common_words$Word)
    
    
    description <- x$description
    description <- subset(description, description !="")
    
    
    desc_corpus <- Corpus(VectorSource(description))
    
    
    dtm <- DocumentTermMatrix(desc_corpus)
    tdm <-DocumentTermMatrix(desc_corpus)
    
    rowTotals <- apply(tdm , 1, sum)
    tdm.new   <- tdm[rowTotals> 0, ] 
    
    freq <- colSums(as.matrix(dtm))
    
    freq_frame <- arrange(data.frame(word = names(freq), freq = freq), desc(freq))
    colnames(freq_frame) <- c("Word", "Count")
    
    tf_idf <- weightTfIdf(tdm.new)
    
    total_tf <- colSums(as.matrix(tf_idf))
    
    tf_frame <- arrange(data.frame(word = names(total_tf), freq = total_tf), desc(total_tf))
    
    
    final_frame_tf <- tf_frame[1:50,]
    final_frame_tf$freq <- round(final_frame_tf$freq,0)
    write.csv(final_frame_tf,file_to_write, row.names = FALSE)
    return(final_frame_tf)
}


get_bigram <- function(file_with_description,outsheet_file){
    library(tm)
    library(xlsx)
    library(dplyr)
    x <- read.csv(file_with_description, header = TRUE)
    filter <- grep("I_WAS_NOT_ASCII", iconv(x$description, "latin1", "ASCII", sub="I_WAS_NOT_ASCII"))
	x <- x[-filter,]
    common_words <- read.xlsx("/Users/harrocyranka/Desktop/code/freq_english_words.xlsx", sheetIndex = 1)
    trim <- function (x) gsub("^\\s+|\\s+$", "", x)
    x$description <- enc2native(x$description)
    
    x$description <- trim(gsub("[^[:alnum:] ]", " ", tolower(x$description)))
    x$description <- trim(gsub("\\s{2,20}"," ", x$description))
    x$description <- removePunctuation(x$description)
    x$description <- removeWords(x$description, common_words$word)
    desc_corpus <- Corpus(VectorSource(x$description))
    
    BigramTokenizer <-
        function(x)
            unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
    
    tdm <- TermDocumentMatrix(desc_corpus, control = list(tokenize = BigramTokenizer))
    freq <- colSums(t(as.matrix(tdm)))
    
    freq_frame <- arrange(data.frame(word = names(freq), freq = freq), desc(freq))
    
    #Clean Twitter Words
    expressions <- read.xlsx("/Users/harrocyranka/Desktop/code/freq_english_words.xlsx", sheetIndex = 2)
    freq_frame <- freq_frame[!freq_frame$word %in% expressions$expression,]
    freq_frame <- freq_frame[1:100,]
    write.csv(freq_frame, outsheet_file, row.names = FALSE)
    return(freq_frame)
    
}

findOffendingCharacter <- function(x, maxStringLength=256){  
    print(x)
    for (c in 1:maxStringLength){
        offendingChar <- substr(x,c,c)
        #print(offendingChar) #uncomment if you want the indiv characters printed
        #the next character is the offending multibyte Character
        #try(lapply(string_vector, findOffendingCharacter)) -  To run the functions
    }    
}