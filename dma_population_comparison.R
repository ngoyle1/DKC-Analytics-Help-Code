dma_population_compariosn <- function(dma_file, platform){
  x <- read_excel(dma_file, )
  x$rank <- 1:nrow(x)
  y <- read_excel("/Users/harrocyranka/Desktop/code/dma_name_translator.xlsx")
  colnames(y) <- c("dma_name", "dma_fb")
  z <- sqldf("SELECT x.*,y.dma_name FROM
             x JOIN y ON x.dma = y.dma_fb")
  z2 <- read.csv("/Users/harrocyranka/Desktop/code/dmas_coordinates2.csv")
  
  z3 <- sqldf("SELECT z.*,z2.latitude, z2.longitude
              FROM z JOIN z2 ON z.dma_name = z2.dma1")
  
  ##Create Comparison Workbook
  k <- read_excel("/Users/harrocyranka/Desktop/code/dma_population.xlsx", sheet = 2)
  colnames(k) <- c("old_name","new_name","rank","population", "tv_hh")
  k <- arrange(k, desc(population))
  k$population_rank <- 1:nrow(k)
  rank_comp <- sqldf("SELECT z.*, k.population_rank FROM
                     z JOIN k ON z.dma_name = k.new_name")
  rank_comp <- select(rank_comp, dma_name,count, rank, population_rank)
  rank_comp$comparison <- ifelse(rank_comp$rank == rank_comp$population_rank, "Same",
                                 ifelse(rank_comp$rank > rank_comp$population_rank,"Lower", "Higher"))
  colnames(rank_comp) <- c("DMA","Total Audience", "Audience Rank", "Population Rank", "Comparison")
  
  ##
  write.xlsx(rank_comp, paste(platform,"_","dma_comparison_with_population.xlsx", sep = ""), row.names = FALSE)
}