return_email_list <- function(my_list){
  x <- read_excel(my_list, sheet = 1)
  
  ##Fix DNC Voters##
  dnc_voters <- filter(x, Sheet == "DNC Voters")
  dnc_voters$Email <- my_coalesce(dnc_voters$Email,"delete_row")
  dnc_voters$Score <- my_coalesce(dnc_voters$Score,0)
  dnc_voters <- filter(dnc_voters, Email != "delete_row")
  dnc_voters$Email <- tolower(dnc_voters$Email)
  
  ##Fix EDS##
  ed <- filter(x, Sheet == "ED")
  ed$Email <- my_coalesce(ed$Email,"delete_row")
  ed <- filter(ed, Email %ni% c("delete_row","VACANT"))
  ed$Score <- my_coalesce(ed$Score,0)
  ed$Email <- tolower(ed$Email)
  
  ##Join##
  y <- as.data.frame(rbind(dnc_voters,ed))
  return(y)
  
}

k <- return_email_list("to_cut_email.xlsx")

write.csv(k, "list_feb_2.csv", row.names = FALSE)