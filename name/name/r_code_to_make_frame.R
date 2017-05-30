remove(list = ls())
options(scipen = 999)
options(stringsAsFactors = FALSE)

setwd("/Users/harrocyranka/Desktop/code/name/name/")

xy <- read.csv("list_of_male_names.csv", header = TRUE)
xx <- read.csv("list_of_female_names.csv", header = TRUE)

xx$gender <- "F"
##Get Unique Female Names Data Frame##
list_of_male_names <- xy$name

unique_xx <- xx[!xx$name %in% list_of_male_names,]
colnames(unique_xx)[3] <- "female_count"

unique_xx$male_count <- 0 


##Get Unique Male Names Data Frame##
list_of_female_names <- xx$name
unique_xy <- xy[!xy$name %in% list_of_female_names,]

colnames(unique_xy)[3] <- "male_count"
unique_xy$female_count <- 0

unique_xy <- unique_xy[,c(1,2,4,3)]

###Now we merge the frame of common names##

shared_names <- sqldf("SELECT xx.name,xx.gender,xx.count as 'female_count',
                      xy.count as 'male_count' FROM xx JOIN xy ON xx.name = xy.name")

##Now we put everything together with rbind##

all_names <- rbind(shared_names, unique_xx,unique_xy)


##Basic Metrics##
all_names$p_female <- all_names$female_count/(all_names$female_count + all_names$male_count) 

all_names$odds_female <- all_names$p_female/(1 - all_names$p_female)
all_names$log_ods_female <- log(all_names$odds_female)

all_names <- all_names[order(-all_names$odds_female),]


write.csv(all_names,"names_with_probabilities.csv", row.names = FALSE)