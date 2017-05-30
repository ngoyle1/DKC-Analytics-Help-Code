fix_ajungo <- function(excel_file){
  library(readxl)
  options(stringsAsFactors = FALSE)
  category_vector <- c("actor","artist","politician",
                       "athlete","clothing","product_service",
                       "comedian","company","public_figure",
                       "entertainer","food_beverage","sports_league",
                       "govt_organization","magazine","sports_team",
                       "media_news","musician","tv_network",
                       "non_profit","media_news_website","tv_show")
  f <- read_excel(excel_file, sheet = 1)
  f <- f[complete.cases(f),]
  
  empty_vector <- NULL
  
  odd_columns <- seq(1,ncol(f),2)
  even_numbers <-seq(2,ncol(f),2)
  
  
  for(i in odd_columns){
    vector <- as.vector(t(f[,i]))
    empty_vector <- append(empty_vector, vector)
  }
  
  numbers <- NULL
  for(i in even_numbers){
    vector_1 <- as.vector(t(f[,i]))
    numbers <- append(numbers, vector_1)
  }
  
  g <- as.data.frame(cbind(empty_vector,numbers))
  g$numbers <- as.numeric(round(as.numeric(g$numbers), digits = 4))
  return(g)
}

ajungo_overlap <- function(list_1, list_2){
  k <- merge(list_1,list_2, by = c("empty_vector","category"))
  colnames(k) <- c("name", "category","percent_1","percent_2")
  k <- k[order(k$category),]
  return(k)
}

write_ajungo <- function(list_1,excel_file_name){
  library(xlsx)
  vectors_with_categories <- unique(list_1$category)
  first_data_frame <- subset(list_1, list_1$category == vectors_with_categories[1])
  write.xlsx(first_data_frame,file = excel_file_name,
             sheetName = vectors_with_categories[1], row.names = FALSE)
  for(i in 2:length(vectors_with_categories)){
    write.xlsx(subset(list_1, list_1$category == vectors_with_categories[i]),
               file = excel_file_name, sheetName = vectors_with_categories[i],
               row.names = FALSE, append = TRUE)
  }
  
}

ajungo_category<- function(ajungo_fixed_frame, vector_with_categories){
  ajungo_fixed_frame$category <- rep(vector_with_categories, each = 10)
  return(ajungo_fixed_frame)
}