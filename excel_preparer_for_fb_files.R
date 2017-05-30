excel_preparer <- function(excel_file){
    source("/Users/harrocyranka/Desktop/code/script_to_load_packages.R")
    
    income_pivot <- function(excel_file){
        income_categories <- c("Under 50K", "Under 50K","50K - 75K", "75K - 100K",
                               "100K - 150K", "100K - 150K","Over 150K","Over 150K","Over 150K","Over 150K")
        x <- read.xlsx(excel_file, sheetName = "income")
        x$income_categories <- income_categories
        y <- aggregate(Count ~income_categories, data = x, sum)
        define_order <- c("Under 50K", "50K - 75K", "75K - 100K","100K - 150K", "Over 150K")
        y1 <- y[match(define_order, y$income_categories),]
        y1$proportional <- round(y1$Count/sum(y1$Count),4)
        write.xlsx(y1, excel_file, sheetName = "income_pivot2",row.names = FALSE,append = TRUE)
        return(y1)
    }
    
    age_pivot <- function(excel_file){
        age_categories <- c("Under 30", "Under 30","30-39","30-39","40-49","40-49","50-59","50-59","Over 60")
        x <- read.xlsx(excel_file, sheetName = "age")
        x <- x[2:nrow(x),]
        x$age_categories <- age_categories
        y <- aggregate(Count ~ age_categories, data = x,sum)
        define_order <- c("Under 30","30-39","40-49","50-59","Over 60")
        y1 <- y[match(define_order, y$age_categories),]
        y1$proportional <- round(y1$Count/sum(y1$Count),4)
        write.xlsx(y1, excel_file, sheetName = "age_pivot2",row.names = FALSE,append = TRUE)
        return(y1)
    }
    
    education_pivot <- function(excel_file){
        x <- read.xlsx(excel_file, sheetName = "education")
        x$categories <- ifelse(x$Education %in% c("College Graduate","In Graduate School",
                                                  "Some Graduate School"),"College",
                               ifelse(x$Education %in% c("Doctorate","Professional Degree","Master's Degree"),"Advanced Degree",
                                      ifelse(x$Education == "Unspecified", "Unspecified","Less than College")))
        define_order <- c("Less than College", "College", "Advanced Degree","Unspecified")
        y <- aggregate(Count ~ categories, data = x,sum)
        y1 <- y[match(define_order, y$categories),]
        y2 <- y1[1:3,]
        y2$proportional <- round(y2$Count/sum(y2$Count),4)
        write.xlsx(y2, excel_file, sheetName = "education_pivot2",row.names = FALSE,append = TRUE)
        return(y2)
    }
    
    geo_pivot <- function(excel_file){
        x <- read.xlsx(excel_file, sheetName ="state")
        z <- read.xlsx(excel_file, sheetName = "state")
        z1 <- get_regions_fb(z)
        y <- get_regions_fb(x)
        y1 <- aggregate(Count ~ Region, data = y, sum)
        y1$proportional <- round(y1$Count/sum(y1$Count),4)
        write.xlsx(y1, excel_file, sheetName = "geo_pivot2", row.names = FALSE, append = TRUE)
        write.xlsx(z1, excel_file, sheetName = "states_with_regions", row.names = FALSE, append = TRUE)
        return(y1)
    }
    
    
    
    fix_gender <- function(excel_file){
    	x <- read.xlsx(excel_file, sheetName = "gender")
    	x$Count <- as.numeric(x$Count)	
    	x$percent <- round(x$Count/sum(x$Count),4)
    	write.xlsx(as.data.frame(x),excel_file,sheetName = "gender_fixed",row.names = FALSE, append = TRUE)
    }
    
    fix_ideology <- function(excel_file){
      x <- read.xlsx(excel_file, sheetName = "ideology")
      rows_to_keep <- c("Very Liberal","Liberal", "Moderate", "Conservative", "Very Conservative")
      x <- filter(x, Politics %in% rows_to_keep)
      x$Count <- as.numeric(as.character(x$Count))
      x$proportional <- round(x$Count/sum(x$Count),4)
      write.xlsx(as.data.frame(x),excel_file,sheetName = "ideology_fixed",row.names = FALSE, append = TRUE)
    }
    
    
    my_excel <- excel_file
    income_pivot(my_excel)
    geo_pivot(my_excel)
    education_pivot(my_excel)
    age_pivot(my_excel)
    fix_gender(my_excel)
    fix_ideology(my_excel)
}

get_regions_fb <- function(data_frame){
  library(sqldf)
  library(xlsx)
  library(readxl)
  data_frame <- data_frame
  my_regions <- read_excel("/Users/harrocyranka/Desktop/code/list_of_regions.xlsx", sheet = 3)
  matched <- sqldf("SELECT data_frame.State as 'state',my_regions.Abbreviation, my_regions.Region, data_frame.Count
                    FROM data_frame LEFT JOIN my_regions ON data_frame.State = my_regions.State")
  return(matched)
}
