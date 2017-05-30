remove(list = ls())
setwd("/Users/francisco06121988/Desktop/dkc/sears/ajungo/from_drive")
source("/Users/francisco06121988/Desktop/dkc/code/functions_to_help_github/ajungo_codes.R")
source("/Users/francisco06121988/Desktop/dkc/code/ajungo_graphs_attempt.R")
options(stringsAsFactors = FALSE)
options(scipen = 999)
library(dplyr)



##done for JCP##
jcp_categories <- c("actor","athlete", "clothing","company","entertainer","
                    entertainment website","food beverage", "health beauty",
                    "magazine","media news", "musician","non-profit", "media news website","product service",
                    "public figure", "tv show", "tv show","website")

jcp <- fix_ajungo("jc_penney.xlsx")

jcp$category <- rep(jcp_categories, each = 10)
jcp <- unique(jcp)

jcp <- arrange(jcp, category, numbers)



##Kmart
kmart_category <- c("actor", "athlete","clothing",
                    "company","entertainer","food beverage","health beauty",
                    "magazine", "media news", "musician","non-profit","news media website","product service",
                    "public figure", "retail","tv show", "tv show", "website")
kmart <- fix_ajungo("kmart.xlsx")


kmart$category <- rep(kmart_category, each = 10)
kmart <- unique(kmart)

kmart <- arrange(kmart, category, numbers)



##Sears
sears_category <- c("actor","company","athlete","entertainer",
                    "clothing","food beverage","magazine","health beauty",
                    "news media","musician","non-profit","news media website","product service",
                    "public figure","public figure","tv show","retail","website")
sears <- fix_ajungo("sears.xlsx")


sears$category <- rep(sears_category, each = 10)
sears <- unique(sears)

sears <- arrange(sears, category, numbers)



##Lowes
lowes_category <- c("actor","athlete","entertainer","company",
                    "food beverage","government organization","media news","magazine",
                    "musician","news media website","non profit", "product service",
                    "public figure","retail","tv show", "website")

lowes <- fix_ajungo("lowes.xlsx")

lowes$category <- rep(lowes_category,each = 10)
lowes <- unique(lowes)

lowes <- arrange(lowes, category, numbers)


##Create Graphs
#Sears
dir.create("sears_graph_dump")
setwd("sears_graph_dump/")
sears_category <- tolower(sears_category)

create_graphs(sears,unique(sears_category),"dark blue")

#jcp
setwd("..//")
dir.create("jcp_data_dump")
setwd("jcp_data_dump/")

create_graphs(jcp,unique(jcp_categories),"orange")

#kmart
setwd("..//")
dir.create("kmart_graph_dump")
setwd("kmart_graph_dump/")

create_graphs(kmart, unique(kmart_category), "red")

#Lowes
setwd("..//")
dir.create("lowes_data_dump")
setwd("lowes_data_dump/")

create_graphs(lowes, unique(lowes_category), "green")
