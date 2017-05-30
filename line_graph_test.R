

setwd("/Users/harrocyranka/Desktop/Research_and_Projects/basketball/")

test_1 <- c("nba_insta.xlsx","politics_insta.xlsx","ncaa_insta.xlsx")
library(readxl)
library(dplyr)
k <- line_graph_income(test_1, c("NBA", "Politics",'NCAA'))
k2 <- line_graph_geo(test_1, c("NBA", "Politics",'NCAA'))
k3 <- line_graph_education(test_1, c("NBA","Politics","NCAA"))
k4 <- line_graph_gender(test_1, c("NBA","Politics","NCAA"))


setwd("/Users/harrocyranka/Desktop/Research_and_Projects/ad_hoc/hormel/")


test_1 <- c("natural_and_organics.xlsx","food_network.xlsx")
names_1 <- c("one", "two")

k5 <- line_graph_ethnicity(test_1, names_1)
k6 <- line_graph_age(test_1, names_1)

create_line_graph_workbook(c("natural_and_organics.xlsx","food_network.xlsx","fresh_and_healthy.xlsx"), c("nat_organics","food_network","fresh_and_healthy"),"line_test.xlsx")