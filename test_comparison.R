remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)

setwd("/Users/harrocyranka/Desktop/for_comparison/")
source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")

x <- read.xlsx("sephora_fb.xlsx",sheetName = "states_with_regions")
y <- read.xlsx("ulta_beauty_fb.xlsx", sheetName =  "states_with_regions")
colnames(x)[4] <- "Sephora"
colnames(y)[4] <- "Ulta"

x$proportional <- round(x[,4]/sum(x[,4]),4)
y$proportional <- round(y[,4]/sum(y[,4]),4)

colnames(x)[5] <- paste(tolower(colnames(x)[4]),"proportional",sep = "_")
colnames(y)[5] <- paste(tolower(colnames(y)[4]),"proportional",sep = "_")

##Merge
z <- as.data.frame(cbind(x, y[,5]))
colnames(z)[6] <- colnames(y)[5]
head(z)
z$difference <- z[,5] - z[,6]


##Create the function
create_map_difference <- function(first_file, second_file, name_1, name_2){
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  
  x <- read.xlsx(first_file,sheetName = "states_with_regions")
  y <- read.xlsx(second_file, sheetName =  "states_with_regions")
  colnames(x)[4] <- name_1
  colnames(y)[4] <- name_2
  
  x$proportional <- round(x[,4]/sum(x[,4]),4)
  y$proportional <- round(y[,4]/sum(y[,4]),4)
  
  colnames(x)[5] <- paste(tolower(colnames(x)[4]),"proportional",sep = "_")
  colnames(y)[5] <- paste(tolower(colnames(y)[4]),"proportional",sep = "_")
  
  ##Merge
  z <- as.data.frame(cbind(x, y[,5]))
  colnames(z)[6] <- colnames(y)[5]
  z$difference <- z[,5] - z[,6]
  z[,4] <- NULL
  return(z)
}

test <- create_map_difference("sephora_fb.xlsx", "ulta_beauty_fb.xlsx", "Sephora", "Ulta")

create_age_difference <- function(first_file, second_file, name_1, name_2){
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  
  x <- read.xlsx(first_file,sheetName = "age_pivot2")
  y <- read.xlsx(second_file, sheetName =  "age_pivot2")
  colnames(x)[3] <- name_1
  colnames(y)[3] <- name_2
  
  x$proportional <- round(x[,3]/sum(x[,3]),4)
  y$proportional <- round(y[,3]/sum(y[,3]),4)
  
  colnames(x)[4] <- paste(tolower(colnames(x)[3]),"proportional",sep = "_")
  colnames(y)[4] <- paste(tolower(colnames(y)[3]),"proportional",sep = "_")
  
  ##Merge
  z <- as.data.frame(cbind(x, y[,4]))
  colnames(z)[5] <- colnames(y)[4]
  z$difference <- z[,4] - z[,5]
  z <- z[,-c(2,3)]
  return(z)
  
}
remove(age_test, education_test, income_test,test)

dma_1 <- read_excel("sephora_dmas_fb.xlsx", sheet = 1)
dma_2 <- read_excel("ulta_beauty_dmas.xlsx", sheet = 1)

dma_1 <- arrange(dma_1, desc(count))
dma_2 <- arrange(dma_2, desc(count))

dma_1$rank <- 1:nrow(dma_1)
dma_2$rank <- 1:nrow(dma_2)

z <- sqldf("SELECT dma_1.*, dma_2.rank
           FROM dma_1 JOIN dma_2 ON dma_1.dma = dma_2.dma")

colnames(z)[3:4] <- c("Sephora","Ulta")

z$comparison <- ifelse(z[,3] < z[,4],"Higher",
                       ifelse(z[,3] > z[,4],"Lower","Same"))

l <- create_dma_difference("sephora_dmas_fb.xlsx","ulta_beauty_dmas.xlsx",name_1 = "Sephora","Ulta")

create_difference_workbook("sephora_fb.xlsx", "ulta_beauty_fb.xlsx","Sephora","Ulta","comparison_sephora_ulta.xlsx")