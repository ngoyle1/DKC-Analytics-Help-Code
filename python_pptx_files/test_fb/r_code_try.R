remove(list = ls())
options(stringsAsFactors = FALSE)
options(scipen = 999)
library(DescTools)
library(ReporteRs)
setwd('/Users/harrocyranka/Desktop/python_pptx_files/test_fb/')
source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
age = read_excel("comparison_fb.xlsx", sheet = "age")
transformPercentiles <- function(x){
  y <- round(x*100,2)
  y2 <- paste(as.character(y),"%", sep = "")
  return(y2)
}
age[,2:4] <- apply(age[2:4],2,transformPercentiles)
doc = pptx("test_103.pptx")
mydoc = addSlide(doc, slide.layout = 'Two Content')

mydoc <- addFlexTable(mydoc, vanilla.table(age),offx = par.properties(text.align = "center"))

writeDoc(mydoc, file = "r-reporters-word-document-add-table.pptx")
