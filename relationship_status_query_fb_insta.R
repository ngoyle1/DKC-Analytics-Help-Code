relationship_status_fb <- function(id_vector, name_vector){
  suppressMessages(library(readxl))
  suppressMessages(library(dplyr))
  relationship_vector <- NULL
    for(j in c(1,2,3,4,6,7,8,9,10,11,12,13)){
      relationship_vector[j] <- fbad_reachestimate(targeting_spec = list(
        relationship_statuses = j,
        publisher_platforms = "facebook",
        geo_locations = list(countries = 'US'),
        flexible_spec = list(
          list(interests = data.frame(
            id = id_vector,
            name = name_vector
          ))
        )
      ))$users
      print(paste(" Retrieved", " for ", name_vector,sep = ""))
    }
  relationship_vector <- relationship_vector[(which(complete.cases(relationship_vector) == TRUE))]
  p2<- c("Single","In Relationship","Married", "Engaged",
                    "Not Specified","Civil Union","Domestic Parternership",
                    "Open Relationship","Complicated","Separated","Divorced","Widowed")
  k <- as.data.frame(cbind(p2, relationship_vector))
  colnames(k) <- c("Relationship Status","Count")
  k$Count <- as.numeric(as.character(k$Count))
  return(k)
}


relationship_status_instagram <- function(id_vector, name_vector){
  suppressMessages(library(readxl))
  suppressMessages(library(dplyr))
  relationship_vector <- NULL
  for(j in c(1,2,3,4,6,7,8,9,10,11,12,13)){
    relationship_vector[j] <- fbad_reachestimate(targeting_spec = list(
      relationship_statuses = j,
      publisher_platforms = "instagram",
      geo_locations = list(countries = 'US'),
      flexible_spec = list(
        list(interests = data.frame(
          id = id_vector,
          name = name_vector
        ))
      )
    ))$users
    print(paste(" Retrieved", " for ", name_vector,sep = ""))
  }
  relationship_vector <- relationship_vector[(which(complete.cases(relationship_vector) == TRUE))]
  p2<- c("Single","In Relationship","Married", "Engaged",
         "Not Specified","Civil Union","Domestic Parternership",
         "Open Relationship","Complicated","Separated","Divorced","Widowed")
  k <- as.data.frame(cbind(p2, relationship_vector))
  colnames(k) <- c("Relationship Status","Count")
  k$Count <- as.numeric(as.character(k$Count))
  return(k)
}