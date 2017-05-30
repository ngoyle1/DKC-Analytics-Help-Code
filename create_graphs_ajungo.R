create_graphs <- function(new_frame,category_vector, select_color,dir_to_create){
  dir.create(dir_to_create)
  setwd(dir_to_create)
  options(scipen = 999)
  options(stringsAsFactors = FALSE)
  suppressMessages(library(xlsx))
  suppressMessages(library(ggplot2))
  suppressMessages(library(scales))
  suppressMessages(library(dplyr))
  source("/Users/harrocyranka/Desktop/code/ajungo_codes.R")
  for(i in 1:length(category_vector)){
    data_frame <- arrange(subset(new_frame, new_frame$category ==category_vector[i]),numbers)
    a <- ggplot(data_frame, aes(x = reorder(empty_vector, numbers),y=numbers)) + geom_bar(stat = "identity", color = "black", fill = select_color)
    b <- a + coord_flip() + theme_bw()
    c <- b +labs(x = "",y = "", title = category_vector[i]) + scale_y_continuous(labels = percent, limits = c(0,max(data_frame$numbers+0.1)))
    d <- c + geom_text(data = data_frame, aes(label = paste(round(data_frame$numbers*100,2),"%", sep="")
    ),color = "black", position = position_dodge(0.9),hjust = -0.15, size = 3)
    e <- d + theme(text = element_text(size = 10.5))
    ggsave(paste(unique(category_vector[i]),".png" ,sep=""),plot = e, width = 10, height = 7, units = "in")  
    
}
}  
  