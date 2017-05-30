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
  colnames(z) <- c("Category", name_1, name_2, "Comparison")
  return(z)
  
}

create_income_difference <- function(first_file, second_file, name_1, name_2){
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  
  x <- read.xlsx(first_file,sheetName = "income_pivot2")
  y <- read.xlsx(second_file, sheetName =  "income_pivot2")
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
  colnames(z) <- c("Category", name_1, name_2, "Comparison")
  return(z)
  
}
create_education_difference <- function(first_file, second_file, name_1, name_2){
  source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
  
  x <- read.xlsx(first_file,sheetName = "education_pivot2")
  y <- read.xlsx(second_file, sheetName =  "education_pivot2")
  colnames(x)[3] <- name_1
  colnames(y)[3] <- name_2
  
  
  ##Merge
  z <- as.data.frame(cbind(x, y[,3]))
  z$difference <- z[,3] - z[,4]
  colnames(z)[4] <- name_2
  z <- z[complete.cases(z$categories),c(1,3,4,5)]
  colnames(z) <- c("Category", name_1, name_2, "Comparison")
  return(z)
  
}

create_dma_difference <- function(file_1, file_2,name_1,name_2){
  dma_1 <- read_excel(file_1, sheet = 1)
  dma_2 <- read_excel(file_2, sheet = 1)
  
  dma_1 <- arrange(dma_1, desc(count))
  dma_2 <- arrange(dma_2, desc(count))
  
  dma_1$rank <- 1:nrow(dma_1)
  dma_2$rank <- 1:nrow(dma_2)
  
  z <- sqldf("SELECT dma_1.*, dma_2.rank
             FROM dma_1 JOIN dma_2 ON dma_1.dma = dma_2.dma")
  colnames(z)[3:4] <- c(name_1,name_2)
  
  z$comparison <- ifelse(z[,3] < z[,4],"Higher",
                         ifelse(z[,3] > z[,4],"Lower","Same"))
  
  return(z)
}

create_gender_difference <- function(file_1, file_2, name_1,name_2){
  x <- read.xlsx(file_1,sheetName = "gender_fixed")
  y <- read.xlsx(file_2, sheetName = "gender_fixed")
  colnames(x)[3] <- name_1
  colnames(y)[3] <- name_2
  x <- arrange(x, desc(Gender))
  y <- arrange(y, desc(Gender))
  
  ##Merge
  z <- as.data.frame(cbind(x, y[,3]))
  colnames(z)[3:4] <- c(name_1,name_2)
  z$difference <- round(z[,3] - z[,4],4)
  z <- z[complete.cases(z$Gender),]
  colnames(z) <- c("Category","Count",name_1, name_2, "Comparison")
  return(z)
}

create_ethnicity_difference <- function(file_1, file_2, name_1,name_2){
  x <- read.xlsx(file_1,sheetName = "ethnicity")
  y <- read.xlsx(file_2, sheetName = "ethnicity")
  colnames(x)[3] <- name_1
  colnames(y)[3] <- name_2
  
  ##Merge
  z <- as.data.frame(cbind(x, y[,3]))
  colnames(z)[3:4] <- c(name_1,name_2)
  z$difference <- round(z[,3] - z[,4],4)
  colnames(z)[1] <- "ethnic_group"
  z <- z[complete.cases(z$ethnic_group),c(1,3,4,5)]
  colnames(z) <- c("Category", name_1, name_2, "Comparison")
  return(z)
}

create_ideological_differences <- function(file_1, file_2,name_1,name_2){
  x <- read.xlsx(file_1,sheetName = "ideology")
  y <- read.xlsx(file_2, sheetName = "ideology")
  rows_to_keep <- c("Very Liberal","Liberal", "Moderate", "Conservative", "Very Conservative")
  x <- filter(x, Politics %in% rows_to_keep)
  y <- filter(y, Politics %in% rows_to_keep)
  x$Count <- as.numeric(as.character(x$Count))
  y$Count <- as.numeric(as.character(y$Count))
  
  x$proportional <- round(x$Count/sum(x$Count),4)
  y$proportional <- round(y$Count/sum(y$Count),4)
  colnames(x)[3] <- name_1
  colnames(y)[3] <- name_2
  
  ##Merge
  z <- as.data.frame(cbind(x, y[,3]))
  colnames(z)[3:4] <- c(name_1,name_2)
  z$difference <- round(z[,3] - z[,4],4)
  colnames(z)[1] <- "Ideology"
  z <- z[complete.cases(z$Ideology),c(1,3,4,5)]
  colnames(z) <- c("Category", name_1, name_2, "Comparison")
  return(z)
}



create_difference_workbook <- function(my_file_1,my_file_2,my_name_1, my_name_2,file_to_write){
  i <- create_map_difference(my_file_1, my_file_2, my_name_1, my_name_2)
  ii <- create_education_difference(my_file_1, my_file_2, my_name_1, my_name_2)
  iii <- create_income_difference(my_file_1, my_file_2, my_name_1, my_name_2)
  iv <- create_age_difference(my_file_1, my_file_2, my_name_1, my_name_2)
  v <- create_gender_difference(my_file_1, my_file_2, my_name_1, my_name_2)
  vi <- create_ethnicity_difference(my_file_1, my_file_2, my_name_1, my_name_2)
  vii <- create_ideological_differences(my_file_1, my_file_2, my_name_1, my_name_2)
  
  write.xlsx(i, file_to_write, sheetName = "geography",row.names = FALSE, append = FALSE)
  write.xlsx(ii, file_to_write, sheetName = "education",row.names = FALSE, append = TRUE)
  write.xlsx(iii, file_to_write, sheetName = "income",row.names = FALSE, append = TRUE)
  write.xlsx(iv, file_to_write, sheetName = "age",row.names = FALSE, append = TRUE)
  write.xlsx(v, file_to_write, sheetName = "gender",row.names = FALSE, append = TRUE)
  write.xlsx(vi, file_to_write, sheetName = "ethnicity",row.names = FALSE, append = TRUE)
  write.xlsx(vii, file_to_write, sheetName = "ideology",row.names = FALSE, append = TRUE)
  
}