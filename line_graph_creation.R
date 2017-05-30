line_graph_income <- function(list_of_excel_files, list_of_names){
  library(readxl)
  library(xlsx)
  library(dplyr)
  readExcel <- function(x){return(read.xlsx(x, sheetName = "income_pivot2"))}
  firstList <- lapply(list_of_excel_files, readExcel)
  categories <- firstList[[1]]$income_categories
  
  ##Keep Proportional##
  selectColumns <- function(x){return(select(x,proportional))}
  getColumns <- lapply(firstList, selectColumns)
  binding_everything <- do.call(cbind, getColumns)
  categories <- as.data.frame(cbind(categories, binding_everything))
  colnames(categories)[2:ncol(categories)] <- list_of_names
  return(categories)
}

line_graph_geo <- function(list_of_excel_files, list_of_names){
  library(readxl)
  library(dplyr)
  readExcel <- function(x){return(read.xlsx(x, sheetName = "geo_pivot2"))}
  firstList <- lapply(list_of_excel_files, readExcel)
  categories <- firstList[[1]]$Region
  
  ##Keep Proportional##
  selectColumns <- function(x){return(select(x,proportional))}
  getColumns <- lapply(firstList, selectColumns)
  binding_everything <- do.call(cbind, getColumns)
  categories <- as.data.frame(cbind(categories, binding_everything))
  colnames(categories)[2:ncol(categories)] <- list_of_names
  return(categories)
}

line_graph_education <- function(list_of_excel_files, list_of_names){
  library(readxl)
  library(dplyr)
  readExcel <- function(x){return(read.xlsx(x, sheetName = "education_pivot2"))}
  firstList <- lapply(list_of_excel_files, readExcel)
  categories <- firstList[[1]]$categories
  
  ##Keep Proportional##
  selectColumns <- function(x){return(select(x,proportional))}
  getColumns <- lapply(firstList, selectColumns)
  binding_everything <- do.call(cbind, getColumns)
  categories <- as.data.frame(cbind(categories, binding_everything))
  colnames(categories)[2:ncol(categories)] <- list_of_names
  return(categories)
}

line_graph_gender <- function(list_of_excel_files, list_of_names){
  library(readxl)
  library(dplyr)
  readExcel <- function(x){return(read.xlsx(x, sheetName = "Sheet1"))}
  firstList <- lapply(list_of_excel_files, readExcel)
  categories <- firstList[[1]]$Gender
  
  ##Keep Proportional##
  selectColumns <- function(x){return(select(x,percent))}
  getColumns <- lapply(firstList, selectColumns)
  binding_everything <- do.call(cbind, getColumns)
  categories <- as.data.frame(cbind(categories, binding_everything))
  colnames(categories)[2:ncol(categories)] <- list_of_names
  return(categories)
}

line_graph_ethnicity <- function(list_of_excel_files, list_of_names){
  library(readxl)
  library(dplyr)
  readExcel <- function(x){return(read.xlsx(x, sheetName = "ethnicity"))}
  firstList <- lapply(list_of_excel_files, readExcel)
  categories <- firstList[[1]][,1]
  
  ##Keep Proportional##
  selectColumns <- function(x){return(select(x,percent))}
  getColumns <- lapply(firstList, selectColumns)
  binding_everything <- do.call(cbind, getColumns)
  categories <- as.data.frame(cbind(categories, binding_everything))
  colnames(categories)[2:ncol(categories)] <- list_of_names
  return(categories)
}

line_graph_age <- function(list_of_excel_files, list_of_names){
  library(readxl)
  library(xlsx)
  library(dplyr)
  readExcel <- function(x){return(read.xlsx(x, sheetName = "age_pivot2"))}
  firstList <- lapply(list_of_excel_files, readExcel)
  categories <- firstList[[1]]$age_categories
  
  ##Keep Proportional##
  selectColumns <- function(x){return(select(x,proportional))}
  getColumns <- lapply(firstList, selectColumns)
  binding_everything <- do.call(cbind, getColumns)
  categories <- as.data.frame(cbind(categories, binding_everything))
  colnames(categories)[2:ncol(categories)] <- list_of_names
  return(categories)
}


create_line_graph_workbook <- function(my_list, names_list, excel_file_to_write){
  age <- line_graph_age(my_list, names_list)
  education <- line_graph_education(my_list, names_list)
  ethnicity <- line_graph_ethnicity(my_list, names_list)
  gender <- line_graph_gender(my_list, names_list)
  geo <- line_graph_geo(my_list, names_list)
  income <- line_graph_income(my_list,names_list)
  
  write.xlsx(age, excel_file_to_write, sheetName = "age", row.names = FALSE, append = FALSE)
  write.xlsx(education, excel_file_to_write, sheetName = "education", row.names = FALSE, append = TRUE)
  write.xlsx(ethnicity, excel_file_to_write, sheetName = "ethnicity", row.names = FALSE, append = TRUE)
  write.xlsx(gender, excel_file_to_write, sheetName = "gender", row.names = FALSE, append = TRUE)
  write.xlsx(geo, excel_file_to_write, sheetName = "geography", row.names = FALSE, append = TRUE)
  write.xlsx(income, excel_file_to_write, sheetName = "income", row.names = FALSE, append = TRUE)
}